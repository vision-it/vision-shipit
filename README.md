# vision-shipit

[![Build Status](https://travis-ci.org/vision-it/vision-shipit.svg?branch=production)](https://travis-ci.org/vision-it/vision-shipit)

## Usage

Include in the *Puppetfile*:

```
mod vision_shipit:
    :git => 'https://github.com/vision-it/vision-shipit.git,
    :ref => 'production'
```

Usage:
```
 vision_shipit::inotify { 'barfoo': }
```
