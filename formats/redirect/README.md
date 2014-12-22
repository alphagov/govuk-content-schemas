# Redirect format

This format is used to create/update redirect(s) for a given base path. The
Publishing API will register the provided redirect(s) with the router.

Note that this schema has a restricted set of properties at the metadata level,
and no details or links hashes at all. Therefore, it is not constructed by
combining sub-schemas. In addition, there is no frontend version, because
redirects are never seen by the frontend: everything is handled by the router.
