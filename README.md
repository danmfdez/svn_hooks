# Project Title

Centralized management of Subversion Hooks.

## Summary

  - [Getting Started](#getting-started)
  - [Runing the tests](#running-the-tests)
  - [Deployment](#deployment)
  - [Built With](#built-with)
  - [Contributing](#contributing)
  - [Versioning](#versioning)
  - [Authors](#authors)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)

## Getting Started




### Prerequisites

You need to have Subversion server installed. This scripts have been tested in Collabnet Subversion Edge.


### Installing

Copy 'pre' and 'post' folders to your SVN installation path (e.g. /opt/csvn/hooks/).
'hooks.cfg' file must be copied to the 'hooks' directory of each repository where you want to use hooks.

    mkdir /opt/csvn/hooks/
    cp -R pre pro /opt/csvn/hooks/
    cp hooks.cfg /opt/csvn/data/repositories/<repo>/hooks/
    
    
## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code
of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this
repository](https://github.com/PurpleBooth/a-good-readme-template/tags).

## Authors

  - **Daniel Muñoz** - *Provided README Template* -
    [PurpleBooth](https://github.com/PurpleBooth)

## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md)
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for
details
