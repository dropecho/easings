# 1.0.0 (2026-06-27)


* refactor!: rename eases to easings.net vocabulary, reorder scale, add docs ([1084054](https://github.com/dropecho/easings/commit/1084054c71551c5b5a3b43b9d3dc0e2197a80eec))


### Bug Fixes

* Add lib to test so it's installed during ci ([0980abe](https://github.com/dropecho/easings/commit/0980abe4ddfb59f92743373d05a9e90ff20e44ff))
* Add package-lock ([ffb2d8d](https://github.com/dropecho/easings/commit/ffb2d8d77d03feee736d2d7ff39d9985ad5efffc))
* Include lix in dev deps. ([553d017](https://github.com/dropecho/easings/commit/553d017ea0c89fc9628fad9e0f85de2ce79437bd))
* Remove CS build for now. ([e691725](https://github.com/dropecho/easings/commit/e6917252461ad8deac9fc819c375d2ff60d1980f))


### BREAKING CHANGES

* public easing functions were renamed and `scale` now
takes the value first.

- easeIn2..5  -> easeInQuad/Cubic/Quart/Quint
- easeOut2..5 -> easeOutQuad/Cubic/Quart/Quint
- smoothStep2 -> smoothStep
- easeInSine(x) -> easeInSine(t)
- scale(easing, t) -> scale(t, easing)  (value-first, like every other fn)

Also adds a class-level doc, per-function doc comments (which flow into the
exposed JS/dts API), and a usage-oriented README. Tests and benchmarks
updated to match; JS + C# build and the utest suite are green.
