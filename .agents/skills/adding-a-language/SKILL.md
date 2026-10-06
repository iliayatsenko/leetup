---
name: adding-a-language
description: Conventions for adding or changing a language under setup/<lang>/ (setup.sh, script templates, the LANG_SLUG mapping, check/debug/installdeps support, new ports). Use when adding a new language or changing how an existing one is set up.
---

- A language is a folder `setup/<lang>/` with a `setup.sh` that `scripts/setup.sh` sources from inside the problem directory. It gets `RESPONSE`, `ID`, `PROBLEM_SLUG` and the `cleanup_text`, `render_template`, `render_scripts` helpers.
- The directory suffix is the upper-cased `<lang>` argument. If LeetCode's `langSlug` differs from `<lang>`, add it to the `LANG_SLUG` case in `scripts/setup.sh`. That check stops setup for problems that have no snippet in the language.
- Per-problem scripts come from `setup/<lang>/*.sh.tmpl` through `render_scripts`. Only `{{PROBLEM_SLUG}}` is expanded. Generated files are committed, so host-specific values (ports, hosts) are read from env at run time with a default, never baked in.
- `check`, `debug` and `installdeps` just run `<dir>/scripts/<cmd>.sh`. A language without one of them must refuse the command explicitly in `scripts/<cmd>.sh` (see the `-SQL` check), not rely on "script not found".
- A new host port goes in `docker-compose.yaml` as `${VAR:-default}:<fixed container port>`, plus a commented line in `.env.dist` and a row in the README config table.
- The leetup container talks to other containers through the Docker socket (`docker exec <container> …`), not over the network.
