{application, umleitung,
 [{description, "umleitung"},
  {vsn, "0.01"},
  {modules, [
    umleitung,
    umleitung_app,
    umleitung_sup,
    umleitung_web,
    umleitung_deps
  ]},
  {registered, []},
  {mod, {umleitung_app, []}},
  {env, []},
  {applications, [kernel, stdlib, crypto]}]}.
