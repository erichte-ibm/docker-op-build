# Usage
## Building

Nothing special here, run `docker build --tag op-build-image . `.

## Running

To run a build, the basic syntax should look something like this:
```
$ docker run -it --name op-build [optional config] op-build-image
```

Images will be copied to `/images` inside the container.
They can be copied out like so:
```
$ docker cp op-build /images/* /target/path/here
```
*(See the relevant configuration section below to set up auto copying)*


To rebuild using the same container, simply run:
```
$ docker start -a op-build
```
Omit the `-a` flag start the build detached from the container (and thus, hide the output).

Otherwise, to run the container once per build, include the `--rm` flag at the run step, and it will delete itself afterwards.

## Configuration
### Use an existing source tree

The script pulls the source to `/op-build`.
To use a local source tree, provide a volume mount to the local tree at run time.
```
$ git clone $REPO op-build
$ docker run -it -v /home/user/Code/op-build:/op-build op-build-image
```

Alternatively, an empty directory can be provided to pull the source from the script, but persist the tree outside of the container.
This may be useful to inspect a failed build, without having to go through the step of cloning the repo externally first.

**NOTE**: The `op-build` directly must be completely empty, otherwise `git` will complain.

### Automatically copy built images to some external directory

As mentioned before, the script copies the built images to `/images`.
So, similarly to reusing a local `/build` directory, volume mount over the `/images` directory to have them copied outside the container.
```
$ docker run -it -v /home/user/builds:/images op-build-image
```

### Environment Variables

Other behavior of the script can be managed through environment variables.

Variable Name | Default                                 | Description
--------------|-----------------------------------------|------------------------------------------------
`OPB_REPO`    | `http://github.com/open-power/op-build` | Git repository to clone if local is not provided
`OPB_BRANCH`  | `master`                                | Which branch to clone from the repo
`OPB_MACHINE` | `habanero`                              | Target machine defconfig to use
`OPB_FORCE`   |                                         | Force a clone of the git repo *(see note below)*

**NOTE:** Setting `OPB_FORCE` will delete anything in `/op-build`, including whatever may be mounted there.
Be mindful of what is mounted at this path if using this option.

Example:
```
docker run -it -e OPB_BRANCH="master-next" -e OPB_MACHINE="firestone" op-build-image
```
