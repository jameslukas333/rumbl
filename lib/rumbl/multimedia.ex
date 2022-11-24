defmodule Rumbl.Multimedia do
  @moduledoc """
  The Multimedia context.
  """

  import Ecto.Query, warn: false
  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  alias Rumbl.Multimedia.Video
  alias Rumbl.Multimedia.Category

  def create_category!(name) do
    Repo.insert!(%Category{name: name}, on_conflict: :nothing)
  end

  @doc """
  Returns the list of videos.
  """
  def list_videos do
    Repo.all(Video)
  end

  @doc """
  Gets a single video.
  Raises `Ecto.NoResultsError` if the Video does not exist.
  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Creates a video.
  """
  def create_video(%User{} = user, attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a video.
  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  def list_alphabetical_categories do
    Category
    |> Category.alphabetical()
    |> Repo.all()
  end

  @doc """
  Deletes a video.

  ## Examples

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{data: %Video{}}

  """
  def change_video(%Video{} = video, attrs \\ %{}) do
    Video.changeset(video, attrs)
  end

  def list_user_videos(%User{} = user) do
    Video
    |> user_videos_query(user)
    |> Repo.all()
  end

  def get_user_video!(%User{} = user, id) do
    Video
    |> user_videos_query(user)
    |> Repo.get!(id)
  end

  defp user_videos_query(query, %User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end
end
