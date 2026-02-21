# HyperLnx Custom Skills

This directory contains HyperLnx-proprietary skills.
These are PROTECTED from upstream OpenClaw patches.

## Skills

| Skill | Description | Tier |
|---|---|---|
| audit-pipeline | Full business audit (scrape + analyze + report) | Audit, Pro |
| notion-writer | Write structured reports to Notion | Audit, Pro |
| social-audit | Instagram, Facebook, LinkedIn, X audit | Audit, Pro |
| web-research | Standard web search + summarization | All |
| photo-analysis | Image analysis and description | Lite, Pro |
| sam-gov-monitor | SAM.gov opportunity tracking | Pro |

## Adding a New Skill
1. Create `skills/{skill-name}/SKILL.md`
2. Add any supporting scripts in the same directory
3. Reference the skill name in the relevant product config.yaml
4. Test with `openclaw --product hyperlnx-{tier}`
