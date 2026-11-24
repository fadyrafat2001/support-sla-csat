# Support SLA and CSAT

## Business question
Which ticket categories miss their resolution SLA most often, and are late tickets linked to lower customer satisfaction?

## Data and method
All data is synthetic. It is not real company or customer data. The raw file has 300 ticket rows. Cleaning steps (written in Power Query M in Queries.pq, not yet run in Power BI Desktop; the .pbix embeds the already-cleaned tables):
- Removed 3 duplicate rows, leaving 297 unique tickets.
- Set 12 CSAT scores of 0 (a placeholder, not a real score) to null, leaving 207 valid scores.
- Left SLA status empty for open tickets, so SLA % uses resolved tickets only.
- Used DIVIDE so a category with no resolved tickets shows blank, not 0%. Data Export has 4 tickets, all open.

## Findings
Of 279 resolved tickets, 226 met their SLA (81.0%), and 18 tickets are still open. Billing was lowest at 52.6%, followed by Bug Report (80.0%), Login/Access (89.6%), Feature Request (91.7%) and How-To (93.2%). Average CSAT was 4.28 for tickets that met SLA and 1.97 for breached tickets. Overall average CSAT is 3.85 after cleaning; leaving the zeros in would give 3.63.

## Model and measures
Star schema: FactTickets linked many-to-one to DimDate (with a YearMonth column for chart ordering), DimAgent and DimCategory. Measures: Tickets, Resolved Tickets, Met SLA Tickets, SLA Met %, Avg Resolution Hours, Open Backlog, Avg CSAT, Avg CSAT Breached. The report has two pages: SLA overview, and agents and satisfaction.

## Limits
Small synthetic sample, for illustration only. The CSAT gap shows an association, not a cause. Results for small categories are not reliable.

## Status
Results were recomputed in Python (pandas) and the DAX was checked with a third-party DAX engine. The generated .pbix file has not yet been opened in Power BI Desktop and still needs to be tested there.

## Provenance
Design (schema, measures, report pages, data rules) was drafted with Claude, then implemented by a separate tool chain. Data generation, the .pbix build and all number checks were done outside Claude. Nothing here is verified by Claude or by Power BI Desktop. Prepared with assistant support, not prior independent work or a real company engagement.
