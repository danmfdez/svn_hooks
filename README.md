# SVN Hooks

Centralized management of Subversion Hooks.

## Summary

  - [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installing](#installing)
  - [Authors](#authors)
  - [License](#license)

## Getting Started

You can manage all your hooks in a single location and deploy them in the different repositories only by editing a single(\*) configuration file (hooks.cfg).  
(\*) Some hooks scripts have their own configuration file.


### Prerequisites

You need to have Subversion server installed. This scripts have been tested in Collabnet Subversion Edge.


### Installing

- Copy 'pre' and 'post' folders to your SVN installation path (e.g. /opt/csvn/hooks/).
- Rename 'hooks.cfg.example' file to 'hooks.cfg' in 'hooks' directory of each repository where you want to use hooks. Edit the file according to your needs.
- Create a link to pre-commit or/and post-commit file in pre and post folder en each hooks repository folder do you want to activate hooks.

```shell
    mkdir /opt/csvn/hooks/
    cp -R pre pro /opt/csvn/hooks/
    cp hooks.cfg.example /opt/csvn/data/repositories/<repo>/hooks/hooks.cfg
    ln -s /opt/csvn/data/repositories/<repo>/hooks/pre-commit /opt/csvn/hooks/pre/pre-commit
    ln -s /opt/csvn/data/repositories/<repo>/hooks/post-commit /opt/csvn/hooks/post/post-commit
```
        
## Authors

  - **Daniel Muñoz** (https://github.com/danmfdez)


## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md)  
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for details
