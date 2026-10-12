# mobai-dev trial brief (for the cloud agent)

You are evaluating mobai-dev, a tool that lets coding agents preview, build and
run iOS apps from a Linux sandbox. Sam wants to know whether it is useful and
whether it behaves safely. Report facts you observed, not the vendor's claims.

## Rules

- Work only in this repository. It is a throwaway app with no secrets.
- Add no signing certificates and no Tailscale or phone setup.
  `MOBAI_SKIP_TAILSCALE=1` is set; keep it that way.
- The simulator test (step 6) needs `MOBAI_API_KEY` as a GitHub repo secret.
  You can't set secrets from this sandbox, so when you reach step 6, ask Sam to
  add it under the repo's Settings > Secrets and variables > Actions. Add no
  other secrets.
- Do not decompile or reverse-engineer the mobai-dev binaries (their license
  forbids it). Observe behavior only.
- Ask Sam in chat when the tool needs his MobAI sign-in code or a GitHub approval.
- Give every log stream or watcher a time limit.

## Tests, in order

Record start time, end time and result for each.

1. **Install record:** run `ls -la ~/.mobai ~/.claude/skills ~/.agents/skills`,
   print `~/.claude/settings.json` and `~/.codex/AGENTS.md`, and run
   `~/.mobai/bin/mobai-dev --version`. Note whether the installed version
   differs from 1.3.4 (the installer can upgrade itself from a vendor manifest).
2. **Network baseline:** start a capture of outbound connections for the whole
   session (for example `ss -tnp` sampled every 5 seconds into a file, or
   `tcpdump -nn -i any 'tcp[tcpflags] & tcp-syn != 0'` if available). Resolve
   the remote IPs to hostnames at the end.
3. **Local API auth:** with mobai-dev running, call
   `curl -s http://127.0.0.1:8686/api/v1/devices` and two other endpoints you
   find in its skills, with no credentials. Record what answers without auth.
4. **Preview:** run `mobai-dev setup --agent claude --framework swiftui`, then
   preview the app. Screenshot the list screen, add a plant named "Mint", open
   it, tap "Water it", screenshot again. Note anything rendered wrong or missing.
5. **Build:** `mobai-dev build --ios` (unsigned). Record total time and whether
   the artifact appears.
6. **Simulator:** `mobai-dev sim start`, repeat the step 4 flow on the real
   simulator, screenshot the same two screens, and release the simulator when
   done. Record time to a usable simulator.
7. **Fidelity:** compare the step 4 and step 6 screenshots side by side.
8. **Network report:** list every remote host contacted, by step. Flag any host
   not in this list: mobai.run, *.mobai.run, tailscale.com, github.com,
   *.githubusercontent.com, registry.npmjs.org, deviceboxhq.com, gs.apple.com,
   pdomnyovfhqsjhgtixub.supabase.co, and the Anthropic API.

## Report

Write `TRIAL-REPORT.md` in this repo with: a one-paragraph verdict, a table of
the eight tests (result, time, evidence), the screenshots, the host list, and
anything that surprised you. Commit it on a branch named `trial-report` and push
that branch. Do not merge it.
