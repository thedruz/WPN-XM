## Contributing to the WPN-XM Server Stack

We'd love for you to contribute to our source code and to make the WPN-XM Server Stack
even better than it is today! Here are the guidelines we'd like you to follow:

## Code of Conduct

Help us keep WPN-XM open and inclusive. Please read and follow our [Code of Conduct][conduct].

## Got a Question or Problem?

If you have questions about how to use WPN-XM, please direct these to [StackOverflow][stackoverflow] or the [Google Group][groups] discussion list.

### Reporting Issues

When reporting issues, please try to be as descriptive as possible, and include as much relevant information as you can.
A step by step guide on how to reproduce the issue will greatly increase the chances of your issue being resolved in a timely manner.
The chance to reproduce your issue will be much higher, when you provide the full output of commands used and log files.

## Getting Started

The WPN-XM project uses a distributed revision control system for source code called git.
All our repositories are Git repositories and hosted over at [Github][github].

You might see the list of repostories by looking at our [organization account][github-org].


* Make sure you have a [GitHub account][github-account].
* Submit a ticket for your issue, assuming one does not already exist.
  * Clearly describe the issue including steps to reproduce when it is a bug.
  * Make sure you fill in the earliest version that you know has the issue.
* Fork the repository on GitHub
* Create a feature or bugfix branch for the issue you want to work on
* Work on the feature and commit your work
* Send us a pull request

### Contributing policy

To ensure a consistent code base, you should make sure the code follows some basic Coding Standards.
For instance, for our PHP applications, make sure to follow [PSR-2][psr-2]. You might also run `php-cs-fixer`
with the configuration file `.php_cs` that can be found in the project root directory.

If you would like to help, take a look at the list of open issues.

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

### What are "Mentored Issues"?

Often junior contributors are not comfortable enough with the code-base to understand which tasks affect which other things
or which route to take for a problem solution and its implementation.

Because we want certain issues fixed and a more experienced developer understands how this can be done,
then he will mentor the specific tasks for this issue.

A "Mentored Issue" provides
- a clear description of the problem (steps to reproduce the issue)
- links to relevant documentation, code, failing tests other needed resources
- and clear steps that should be taken for the fix.

The mentor will answer questions, review changes, and make the process as easy as possible.
In fact, there are lots of smart people out there, who can get things done, when given the right tools and support.

To get started: simply pick an issue.

### Closing policy for issues and merge requests

WPN-XM is a popular open source project and the capacity to deal with issues and merge requests is limited.
Out of respect for our volunteers, issues and merge requests not in line with the [Code of Conduct][conduct]
or the guidelines listed in this document may be closed without further notice.

[github]: http://github.com/
[github-org]: https://github.com/WPN-XM
[github-help]: http://help.github.com/
[github-account]: https://github.com/signup/free
[issues-easypicks]: https://github.com/WPN-XM/WPN-XM/issues?q=is%3Aopen+is%3Aissue+label%3A%22easy+pick%22
[psr-2]: https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-2-coding-style-guide.md
[conduct]: https://github.com/WPN-XM/WPN-XM/blob/master/CODE_OF_CONDUCT.md
[groups]: https://groups.google.com/forum/#!forum/wpn-xm
[stackoverflow]: http://stackoverflow.com/questions/tagged/wpn-xm
