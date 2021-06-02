# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hello.Repo.insert!(%Hello.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Hello.Accounts.User
alias Hello.Repo

%User{name: "Admin", email: "admin@admin.com", password: "supersecret", is_admin: true} |> Repo.insert!
%User{name: "User", email: "test@test.com", password: "secret", is_admin: false} |> Repo.insert!
