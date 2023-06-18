create role admin;
create role app_user;
create role anonymous;

create schema app_public;
create schema app_private;

alter default privileges revoke execute on functions from public;
grant usage on schema app_public to admin, app_user, anonymous;
grant usage on schema app_private to admin;
