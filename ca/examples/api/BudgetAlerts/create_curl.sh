curl https://analytics.rightscale.com/api/scheduled_reports \
      -H X-Api-Version:1.0 \
      -H Content-Type:application/json \
      -b rightscalecookies \
      -d '{"frequency":"monthly","additional_emails":["additional@example.com"],"filters":[{"type":"instance:instance_type_key","value":"5::m1.large","label":"m1.large"}],"name":"Report Title","attach_csv":true}'