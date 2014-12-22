# Redirect format

This format is used when a document is unpublished with an automatic redirect
to another URL. The publishing API registers the redirect with the router API.

Note that this schema has a restricted set of properties at the metadata level,
and no details or links hashes at all. Therefore, it is not constructed by
combining sub-schemas. In addition, there is no frontend version, because
redirects are never seen by the frontend: everything is handled by the router.
