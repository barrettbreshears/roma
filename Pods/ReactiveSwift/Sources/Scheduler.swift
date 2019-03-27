//
//  Scheduler.swift
//  ReactiveSwift
//
//  Created by Justin Spahr-Summers on 2014-06-02.
//  Copyright (c) 2014 GitHub. All rights reserved.
//

import Dispatch
import Foundation

#if os(Linux)
	import let CDispatch.NSEC_PER_SEC
#endif

/// Represents a serial queue of work items.
public protocol Scheduler: class {
	/// Enqueues an action on the scheduler.
	///
	/// When the work is executed depends on the scheduler in use.
	///
	/// - parameters:
	///   - action: The action to be scheduled.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///            before it begins.
	@discardableResult
	func schedule(_ action: @escaping () -> Void) -> Disposable?
}

/// A particular kind of scheduler that supports enqueuing actions at future
/// dates.
public protocol DateScheduler: Scheduler {
	/// The current date, as determined by this scheduler.
	///
	/// This can be implemented to deterministically return a known date (e.g.,
	/// for testing purposes).
	var currentDate: Date { get }

	/// Schedules an action for execution at or after the given date.
	///
	/// - parameters:
	///   - date: The start date.
	///   - action: A closure of the action to be performed.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///            before it begins.
	@discardableResult
	func schedule(after date: Date, action: @escaping () -> Void) -> Disposable?

	/// Schedules a recurring action at the given interval, beginning at the
	/// given date.
	///
	/// - parameters:
	///   - date: The start date.
	///   - interval: A repetition interval.
	///   - leeway: Some delta for repetition.
	///   - action: A closure of the action to be performed.
	///
	///	- note: If you plan to specify an `interval` value greater than 200,000
	///			seconds, use `schedule(after:interval:leeway:action)` instead
	///			and specify your own `leeway` value to avoid potential overflow.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///            before it begins.
	@discardableResult
	func schedule(after date: Date, interval: DispatchTimeInterval, leeway: DispatchTimeInterval, action: @escaping () -> Void) -> Disposable?
}

/// A scheduler that performs all work synchronously.
public final class ImmediateScheduler: Scheduler {
	public init() {}

	/// Immediately calls passed in `action`.
	///
	/// - parameters:
	///   - action: A closure of the action to be performed.
	///
	/// - returns: `nil`.
	@discardableResult
	public func schedule(_ action: @escaping () -> Void) -> Disposable? {
		action()
		return nil
	}
}

/// A scheduler that performs all work on the main queue, as soon as possible.
///
/// If the caller is already running on the main queue when an action is
/// scheduled, it may be run synchronously. However, ordering between actions
/// will always be preserved.
public final class UIScheduler: Scheduler {
	private static let dispatchSpecificKey = DispatchSpecificKey<UInt8>()
	private static let dispatchSpecificValue = UInt8.max
	private static var __once: () = {
			DispatchQueue.main.setSpecific(key: UIScheduler.dispatchSpecificKey,
			                               value: dispatchSpecificValue)
	}()

	#if os(Linux)
	private var queueLength: Atomic<Int32> = Atomic(0)
	#else
	// `inout` references do not guarantee atomicity. Use `UnsafeMutablePointer`
	// instead.
	//
	// https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20161205/004147.html
	private let queueLength: UnsafeMutablePointer<Int32> = {
		let memory = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
		memory.initialize(to: 0)
		return memory
	}()

	deinit {
		queueLength.deallocate()
	}
	#endif

	/// Initializes `UIScheduler`
	public init() {
		/// This call is to ensure the main queue has been setup appropriately
		/// for `UIScheduler`. It is only called once during the application
		/// lifetime, since Swift has a `dispatch_once` like mechanism to
		/// lazily initialize global variables and static variables.
		_ = UIScheduler.__once
	}

	/// Queues an action to be performed on main queue. If the action is called
	/// on the main thread and no work is queued, no scheduling takes place and
	/// the action is called instantly.
	///
	/// - parameters:
	///   - action: A closure of the action to be performed on the main thread.
	///
	/// - returns: `Disposable` that can be used to cancel the work before it
	///            begins.
	@discardableResult
	public func schedule(_ action: @escaping () -> Void) -> Disposable? {
		let positionInQueue = enqueue()

		// If we're already running on the main queue, and there isn't work
		// already enqueued, we can skip scheduling and just execute directly.
		if positionInQueue == 1 && DispatchQueue.getSpecific(key: UIScheduler.dispatchSpecificKey) == UIScheduler.dispatchSpecificValue {
			action()
			dequeue()
			return nil
		} else {
			let disposable = AnyDisposable()

			DispatchQueue.main.async {
				defer { self.dequeue() }
				guard !disposable.isDisposed else { return }
				action()
			}

			return disposable
		}
	}

	private func dequeue() {
		#if os(Linux)
			queueLength.modify { $0 -= 1 }
		#else
			OSAtomicDecrement32(queueLength)
		#endif
	}

	private func enqueue() -> Int32 {
		#if os(Linux)
		return queueLength.modify { value -> Int32 in
			value += 1
			return value
		}
		#else
		return OSAtomicIncrement32(queueLength)
		#endif
	}
}

/// A scheduler backed by a serial GCD queue.
public final class QueueScheduler: DateScheduler {
	/// A singleton `QueueScheduler` that always targets the main thread's GCD
	/// queue.
	///
	/// - note: Unlike `UIScheduler`, this scheduler supports scheduling for a
	///         future date, and will always schedule asynchronously (even if 
	///         already running on the main thread).
	public static let main = QueueScheduler(internalQueue: DispatchQueue.main)

	public var currentDate: Date {
		return Date()
	}

	public let queue: DispatchQueue

	internal init(internalQueue: DispatchQueue) {
		queue = internalQueue
	}

	/// Initializes a scheduler that will target the given queue with its
	/// work.
	///
	/// - note: Even if the queue is concurrent, all work items enqueued with
	///         the `QueueScheduler` will be serial with respect to each other.
	///
	/// - warning: Obsoleted in OS X 10.11
	@available(OSX, deprecated:10.10, obsoleted:10.11, message:"Use init(qos:name:targeting:) instead")
	@available(iOS, deprecated:8.0, obsoleted:9.0, message:"Use init(qos:name:targeting:) instead.")
	public convenience init(queue: DispatchQueue, name: String = "org.reactivecocoa.ReactiveSwift.QueueScheduler") {
		self.init(internalQueue: DispatchQueue(label: name, target: queue))
	}

	/// Initializes a scheduler that creates a new serial queue with the
	/// given quality of service class.
	///
	/// - parameters:
	///   - qos: Dispatch queue's QoS value.
	///   - name: A name for the queue in the form of reverse domain.
	///   - targeting: (Optional) The queue on which this scheduler's work is
	///     targeted
	@available(OSX 10.10, *)
	public convenience init(
		qos: DispatchQoS = .default,
		name: String = "org.reactivecocoa.ReactiveSwift.QueueScheduler",
		targeting targetQueue: DispatchQueue? = nil
	) {
		self.init(internalQueue: DispatchQueue(
			label: name,
			qos: qos,
			target: targetQueue
		))
	}

	/// Schedules action for dispatch on internal queue
	///
	/// - parameters:
	///   - action: A closure of the action to be scheduled.
	///
	/// - returns: `Disposable` that can be used to cancel the work before it
	///            begins.
	@discardableResult
	public func schedule(_ action: @escaping () -> Void) -> Disposable? {
		let d = AnyDisposable()

		queue.async {
			if !d.isDisposed {
				action()
			}
		}

		return d
	}

	private func wallTime(with date: Date) -> DispatchWallTime {
		let (seconds, frac) = modf(date.timeIntervalSince1970)

		let nsec: Double = frac * Double(NSEC_PER_SEC)
		let walltime = timespec(tv_sec: Int(seconds), tv_nsec: Int(nsec))

		return DispatchWallTime(timespec: walltime)
	}

	/// Schedules an action for execution at or after the given date.
	///
	/// - parameters:
	///   - date: The start date.
	///   - action: A closure of the action to be performed.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///            before it begins.
	@discardableResult
	public func schedule(after date: Date, action: @escaping () -> Void) -> Disposable? {
		let d = AnyDisposable()

		queue.asyncAfter(wallDeadline: wallTime(with: date)) {
			if !d.isDisposed {
				action()
			}
		}

		return d
	}

	/// Schedules a recurring action at the given interval and beginning at the
	/// given start date. A reasonable default timer interval leeway is
	/// provided.
	///
	/// - parameters:
	///   - date: A date to schedule the first action for.
	///   - interval: A repetition interval.
	///   - action: Closure of the action to repeat.
	///
	///	- note: If you plan to specify an `interval` value greater than 200,000 
	///			seconds, use `schedule(after:interval:leeway:action)` instead 
	///			and specify your own `leeway` value to avoid potential overflow.
	///
	/// - returns: Optional disposable that can be used to cancel the work
	///            before it begins.
	@discardableResult
	public func schedule(after date: Date, interval: DispatchTimeInterval, action: @escaping () -> Void) -> Disposable? {
		// Apple's "Power Efficiency Guide for Mac Apps" recommends a leeway of
		// at least 10% of the timer interval.
		return schedule(after: date, interval: interval, leeway: interval * 0.1, action: action)
	}

	/// Schedules a recurring action at the given interval with provided leeway,
	/// beginning at the given start time.
	///
	/// - precondition: `interval` must be non-negative number.
	/// - precondition: `leeway` must be non-negative number.
	///
	/// - parameters:
	///   - date: A date to schedule the first action for.
	///   - interval: A repetition interval.
	///   - leeway: Some delta for repetition interval.
	///   - action: A closure of the action to repeat.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///            before it begins.
	@discardableResult
	public func schedule(after date: Date, interval: DispatchTimeInterval, leeway: DispatchTimeInterval, action: @escaping () -> Void) -> Disposable? {
		precondition(interval.timeInterval >= 0)
		precondition(leeway.timeInterval >= 0)

		let timer = DispatchSource.makeTimerSource(
			flags: DispatchSource.TimerFlags(rawValue: UInt(0)),
			queue: queue
		)

		#if swift(>=4.0)
		timer.schedule(wallDeadline: wallTime(with: date),
		               repeating: interval,
		               leeway: leeway)
		#else
		timer.scheduleRepeating(wallDeadline: wallTime(with: date),
		                        interval: interval,
		                        leeway: leeway)
		#endif

		timer.setEventHandler(handler: action)
		timer.resume()

		return AnyDisposable {
			timer.cancel()
		}
	}
}

/// A scheduler that implements virtualized time, for use in testing.
public final class TestScheduler: DateScheduler {
	private final class ScheduledAction {
		let date: Date
		let action: () -> Void

		init(date: Date, action: @escaping () -> Void) {
			self.date = date
			self.action = action
		}

		func less(_ rhs: ScheduledAction) -> Bool {
			return date.compare(rhs.date) == .orderedAscending
		}
	}

	private let lock = NSRecursiveLock()
	private var _currentDate: Date

	/// The virtual date that the scheduler is currently at.
	public var currentDate: Date {
		let d: Date

		lock.lock()
		d = _currentDate
		lock.unlock()

		return d
	}

	private var scheduledActions: [ScheduledAction] = []

	/// Initializes a TestScheduler with the given start date.
	///
	/// - parameters:
	///   - startDate: The start date of the scheduler.
	public init(startDate: Date = Date(timeIntervalSinceReferenceDate: 0)) {
		lock.name = "org.reactivecocoa.ReactiveSwift.TestScheduler"
		_currentDate = startDate
	}

	private func schedule(_ action: ScheduledAction) -> Disposable {
		lock.lock()
		scheduledActions.append(action)
		scheduledActions.sort { $0.less($1) }
		lock.unlock()

		return AnyDisposable {
			self.lock.lock()
			self.scheduledActions = self.scheduledActions.filter { $0 !== action }
			self.lock.unlock()
		}
	}

	/// Enqueues an action on the scheduler.
	///
	/// - note: The work is executed on `currentDate` as it is understood by the
	///         scheduler.
	///
	/// - parameters:
	///   - action: An action that will be performed on scheduler's
	///             `currentDate`.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///            before it begins.
	@discardableResult
	public func schedule(_ action: @escaping () -> Void) -> Disposable? {
		return schedule(ScheduledAction(date: currentDate, action: action))
	}

	/// Schedules an action for execution after some delay.
	///
	/// - parameters:
	///   - delay: A delay for execution.
	///   - action: A closure of the action to perform.
	///
	/// - returns: Optional disposable that can be used to cancel the work
	///            before it begins.
	@discardableResult
	public func schedule(after delay: DispatchTimeInterval, action: @escaping () -> Void) -> Disposable? {
		return schedule(after: currentDate.addingTimeInterval(delay), action: action)
	}

	/// Schedules an action for execution at or after the given date.
	///
	/// - parameters:
	///   - date: A starting date.
	///   - action: A closure of the action to perform.
	///
	/// - returns: Optional disposable that can be used to cancel the work
	///            before it begins.
	@discardableResult
	public func schedule(after date: Date, action: @escaping () -> Void) -> Disposable? {
		return schedule(ScheduledAction(date: date, action: action))
	}

	/// Schedules a recurring action at the given interval, beginning at the
	/// given start date.
	///
	/// - precondition: `interval` must be non-negative.
	///
	/// - parameters:
	///   - date: A date to schedule the first action for.
	///   - interval: A repetition interval.
	///   - disposable: A disposable.
	///   - action: A closure of the action to repeat.
	///
	///	- note: If you plan to specify an `interval` value greater than 200,000
	///			seconds, use `schedule(after:interval:leeway:action)` instead
	///			and specify your own `leeway` value to avoid potential overflow.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///            before it begins.
	private func schedule(after date: Date, interval: DispatchTimeInterval, disposable: SerialDisposable, action: @escaping () -> Void) {
		precondition(interval.timeInterval >= 0)

		disposable.inner = schedule(after: date) { [unowned self] in
			action()
			self.schedule(after: date.addingTimeInterval(interval), interval: interval, disposable: disposable, action: action)
		}
	}

	/// Schedules a recurring action after given delay repeated at the given,
	/// interval, beginning at the given interval counted from `currentDate`.
	///
	/// - parameters:
	///   - delay: A delay for action's dispatch.
	///   - interval: A repetition interval.
	///	  - leeway: Some delta for repetition interval.
	///   - action: A closure of the action to repeat.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///            before it begins.
	@discardableResult
	public func schedule(after delay: DispatchTimeInterval, interval: DispatchTimeInterval, leeway: DispatchTimeInterval = .seconds(0), action: @escaping () -> Void) -> Disposable? {
		return schedule(after: currentDate.addingTimeInterval(delay), interval: interval, leeway: leeway, action: action)
	}

	/// Schedules a recurring action at the given interval with
	/// provided leeway, beginning at the given start date.
	///
	/// - parameters:
	///   - date: A date to schedule the first action for.
	///   - interval: A repetition interval.
	///	  - leeway: Some delta for repetition interval.
	///   - action: A closure of the action to repeat.
	///
	/// - returns: Optional `Disposable` that can be used to cancel the work
	///	           before it begins.
	public func schedule(after date: Date, interval: DispatchTimeInterval, leeway: DispatchTimeInterval = .seconds(0), action: @escaping () -> Void) -> Disposable? {
		let disposable = SerialDisposable()
		schedule(after: date, interval: interval, disposable: disposable, action: action)
		return disposable
	}

	/// Advances the virtualized clock by an extremely tiny interval, dequeuing
	/// and executing any actions along the way.
	///
	/// This is intended to be used as a way to execute actions that have been
	/// scheduled to run as soon as possible.
	public func advance() {
		advance(by: .nanoseconds(1))
	}

	/// Advances the virtualized clock by the given interval, dequeuing and
	/// executing any actions along the way.
	///
	/// - parameters:
	///   - interval: Interval by which the current date will be advanced.
	public func advance(by interval: DispatchTimeInterval) {
		lock.lock()
		advance(to: currentDate.addingTimeInterval(interval))
		lock.unlock()
	}

	/// Advances the virtualized clock to the given future date, dequeuing and
	/// executing any actions up until that point.
	///
	/// - parameters:
	///   - newDate: Future date to which the virtual clock will be advanced.
	public func advance(to newDate: Date) {
		lock.lock()

		assert(currentDate.compare(newDate) != .orderedDescending)

		while scheduledActions.count > 0 {
			if newDate.compare(scheduledActions[0].date) == .orderedAscending {
				break
			}

			_currentDate = scheduledActions[0].date

			let scheduledAction = scheduledActions.remove(at: 0)
			scheduledAction.action()
		}

		_currentDate = newDate

		lock.unlock()
	}

	/// Dequeues and executes all scheduled actions, leaving the scheduler's
	/// date at `Date.distantFuture()`.
	public func run() {
		advance(to: Date.distantFuture)
	}

	/// Rewinds the virtualized clock by the given interval.
	/// This simulates that user changes device date.
	///
	/// - parameters:
	///   - interval: An interval by which the current date will be retreated.
	public func rewind(by interval: DispatchTimeInterval) {
		lock.lock()

		let newDate = currentDate.addingTimeInterval(-interval)
		assert(currentDate.compare(newDate) != .orderedAscending)
		_currentDate = newDate

		lock.unlock()

	}
}
