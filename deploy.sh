for server in $(govuk_node_list -c backend); do
  rsync -r dist/* deploy@$server:/data/apps/publishing-api/shared/govuk-content-schemas/
done
