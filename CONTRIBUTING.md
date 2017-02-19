## Contributing to the WPN-XM Server Stack

We'd love for you to contribute to our source code and to make the WPN-XM Server Stack
even better than it is today! Here are the guidelines we'd like you to follow:

## Getting Started

The WPN-XM project uses a distributed revision control system for source code called git.
All our repositories are Git repositories and hosted over at [Github][github].
You might see the list of repostories by looking at our [organization account][github-org].
The main repo is [WPN-XM/WPN-XM][github-repo-wpnxm]. It is also used for centralized bug and issue tracking.

### Got a Question? You need support?

If you have questions about how to use WPN-XM, please ask them in the [Forum][forum] or on [StackOverflow][stackoverflow] or the [Mailinglist][groups].

### Reporting Issues

Reporting issues is a great way to became a contributor as it doesn't require technical skills.
In fact you don't even need to know a programming language or to be able to check the code itself,
you just need to make sure that everything works as expected and submit an issue report if you spot a bug.

Sound like something you're up for? Go for it!

When reporting issues, please try to be as descriptive as possible, and include as much relevant information as you can.
A step by step guide on how to reproduce the issue will greatly increase the chances of your issue being resolved in a timely manner.
The chance to reproduce your issue will be much higher, when you provide the full output of commands used and log files.

### How To Submit An Issue Report

If something isn't working, congratulations you've found a bug! Help us fix it by submitting an issue report.

* Make sure you have a [GitHub account][github-account]
* Submit a ticket for your issue, assuming one does not already exist.
  * Clearly describe the issue (including steps to reproduce it if it's a bug).
  * Make sure you fill in the earliest version that you know has the issue.

## Contributing 

If you would like to help, take a look at the list of [open issues][github-issues].

### What are "Easy Picks"?

One of the barriers to convert users into contributors in an open-source projects is that many people have no idea where to start.
They are usually scared to take on large tasks because they are not comfortable enough with the code-base.
They don't know what they can or even want to work on.

We are trying to lower the barrier by labeling certain issues for starters as "Easy Pick"s.
These issues are often not hard to implement and provide a great opportunity to get involved and help the project.
"Easy Picks" are a good starting point for new contributors.

If you don't know where to start or which issue to pick from the list, then filter the Github Issues for the label "Easy Pick"s.
and see if you find anything you can help us with.

[Show Easy Picks][issues-easypicks]

### How To Submit Source

* Fork the repository on GitHub
* Create a feature branch for the issue you want to work on
  - `git checkout -b new-feature`
* Work on the feature and commit your work
  - `git commit -am 'added new-feature'`
* Push to the branch 
  - `git push origin my-new-feature`
* Send us a Pull Request (PR)

#### Pull Requests

* Document any change in behaviour 
  - make sure the official documentation is kept up to date, when introducing changes. update the CHANGELOG.
* Create feature branches 
  - don't create PRs from your master branch. Except, when contributing really small fixes or direct edits via the Github UI, e.g. for typos!
* One pull request per feature.
  - if you want to work on a lot of features, just send multiple PRs.
* Keep coherent history 
  - ensure each individual commit in your pull request is meaningful. 
  - if possible, squash multiple commits before submitting

[github-repo-wpnxm]: https://github.com/WPN-XM/WPN-XM
[github]: http://github.com/
[github-org]: https://github.com/WPN-XM
[github-help]: http://help.github.com/
[github-account]: https://github.com/signup/free
[github-issues]: https://github.com/WPN-XM/WPN-XM/issues
[github-issues-easypicks]: https://github.com/WPN-XM/WPN-XM/issues?q=is%3Aopen+is%3Aissue+label%3A%22easy+pick%22
[psr-2]: https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-2-coding-style-guide.md
[groups]: https://groups.google.com/forum/#!forum/wpn-xm
[stackoverflow]: http://stackoverflow.com/questions/tagged/wpn-xm
[forum]: https://forum.wpn-xm.org/
