# Common evasions and the response

The full catalogue of evasions the empirical-proof gate needs to defeat. The body of `SKILL.md` keeps the top three most-frequent ones inline; the full catalogue (including those three, for completeness) lives here so the agent can pull it up when one of them surfaces in conversation.

| 🚩 Evasion                                                                   | Response                                                                          |
| ---------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| "The output is too long to paste."                                           | The gate asks for the last 2 lines, not the whole log.                            |
| "I already ran it earlier in the session."                                   | Re-run after every change. The earlier run is stale.                              |
| "It's obvious from the diff that the test passes."                           | Diff doesn't run tests. Run the tests; paste the output.                          |
| "The CI will catch it."                                                      | The discipline is the agent's gate, not the CI's.                                 |
| "It would slow down the session."                                            | The session's value is correctness, not speed.                                    |
| "I'm reviewing in good faith — pasting is performative."                     | Treat trust as a vulnerability to remove, not a virtue.                           |
| "The test command failed for environmental reasons unrelated to my changes." | Surface the env issue in `## Blockers`. Do not silently mark the task complete.   |

## How to use this table

When the agent (or the user) catches itself reasoning toward one of these evasions, look up the row, paste the response, and run the verification. The point is not to win the argument — the point is to make the cost of skipping the verification (a public exchange of evasion + response) higher than the cost of just running the command.
