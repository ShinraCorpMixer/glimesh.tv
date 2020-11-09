defmodule Glimesh.CommunityTeam do
  @moduledoc """
  The Community Team context :)
  """
  import Ecto.Query, warn: false
  alias Glimesh.CommunityTeam.AuditLog
  alias Glimesh.Repo

  def access_level_to_title(level) do
    case level do
      5 -> "Admin"
      4 -> "Manager"
      3 -> "Team Lead"
      2 -> "Team Member"
      1 -> "Trial Member"
      _ -> "None"
    end
  end

  def can_edit_user(user) do
    if user.gct_level >= 3, do: true, else: false
  end

  def can_edit_user_profile(user) do
    if user.gct_level >= 2, do: true, else: false
  end

  def can_ban_user(user) do
    if user.gct_level >= 4, do: true, else: false
  end

  def can_delete_user(user) do
    if user.gct_level >= 5, do: true, else: false
  end

  def can_view_audit_log(user) do
    if user.gct_level >= 3, do: true, else: false
  end

  def create_audit_entry(user, attrs \\ %{action: "None", target: "None"}) do
    %AuditLog{
      user: user
    }
    |> AuditLog.changeset(attrs)
    |> Repo.insert()
  end

  def list_all_audit_entries(include_verbose?, params \\ []) do
    entries =
      case include_verbose? do
        true ->
          AuditLog |> order_by(desc: :inserted_at) |> preload(:user) |> Repo.paginate(params)

        false ->
          AuditLog
          |> order_by(desc: :inserted_at)
          |> where([al], al.verbose_required? == false)
          |> preload(:user)
          |> Repo.paginate(params)
      end
  end
end
