//
//  FlightTimePageViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/18/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol FlightTimePageViewControllerDelegate: class {
    /**
    Called when the number of pages is updated.
    - parameter count: the total number of pages.
    */
    func pageViewController(pageViewController: FlightTimePageViewController,
    didUpdatePageCount count: Int)

    /**
    Called when the current index is updated.
    - parameter index: the index of the currently visible page.
    */
    func pageViewController(pageViewController: FlightTimePageViewController,
    didUpdatePageIndex index: Int)
}

class FlightTimePageViewController: UIPageViewController {

    //MARK: - Properties

    weak var tutorialDelegate: FlightTimePageViewControllerDelegate?

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.newPageViewController("1"),
                self.newPageViewController("2")]
    }()

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(viewController: initialViewController)
        }

        tutorialDelegate?.pageViewController(pageViewController: self, didUpdatePageCount: orderedViewControllers.count)
    }

    //MARK: - Methods

    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
           let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
                scrollToViewController(viewController: nextViewController)
        }
    }

    /**
    Scrolls to the view controller at the given index. Automatically calculates the direction.

    - parameter newIndex: the new index to scroll to
    */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
                let nextViewController = orderedViewControllers[newIndex]
                scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }

    func newPageViewController(_ index: String) -> UIViewController {
        return UIStoryboard(name: "Form781", bundle: nil) .
            instantiateViewController(withIdentifier: "Page\(index)")
    }

    /**
    Scrolls to the given 'viewController' page.
    */
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward) {
            setViewControllers([viewController],
            direction: direction,
            animated: true,
            completion: { (finished) -> Void in
            // Setting the view controller programmatically does not fire
            // any delegate methods, so we have to manually notify the
            // 'tutorialDelegate' of the new index.
            self.notifyPageDelegateOfNewIndex()
        })
    }

    ///Notifies 'tutorialDelegate' that the current page index was updated.

    private func notifyPageDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
           let index = orderedViewControllers.firstIndex(of: firstViewController) {
                tutorialDelegate?.pageViewController(pageViewController: self, didUpdatePageIndex: index)
        }
    }

} //End

// MARK: - UIPageViewControllerDataSource

extension FlightTimePageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

    let previousIndex = viewControllerIndex - 1

    // User is on the first view controller and swiped left to loop to the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        // User is on the last view controller and swiped right to loop to the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }

} //End

extension FlightTimePageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifyPageDelegateOfNewIndex()
    }

} //End
