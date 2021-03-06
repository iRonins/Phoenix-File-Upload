defmodule FileUploader.StorageTest do
  use FileUploader.DataCase

  alias FileUploader.Storage

  describe "pictures" do
    alias FileUploader.Storage.Picture

    @valid_attrs %{title: "some title",
                   image: %Plug.Upload{path: "test/fixtures/image.png",
                                       filename: "image.png"}}
    @update_attrs %{title: "some updated title",
                    image: %Plug.Upload{path: "test/fixtures/image.png",
                                        filename: "image.png"}}
    @invalid_attrs %{title: nil}

    def picture_fixture(attrs \\ %{}) do
      {:ok, picture} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Storage.create_picture()

      picture
    end

    test "list_pictures/0 returns all pictures" do
      picture = picture_fixture()
      assert Storage.list_pictures() == [picture]
    end

    test "get_picture!/1 returns the picture with given id" do
      picture = picture_fixture()
      assert Storage.get_picture!(picture.id) == picture
    end

    test "create_picture/1 with valid data creates a picture" do
      assert {:ok, %Picture{} = picture} = Storage.create_picture(@valid_attrs)
      assert picture.title == "some title"
    end

    test "create_picture/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Storage.create_picture(@invalid_attrs)
    end

    test "update_picture/2 with valid data updates the picture" do
      picture = picture_fixture()
      assert {:ok, picture} = Storage.update_picture(picture, @update_attrs)
      assert %Picture{} = picture
      assert picture.title == "some updated title"
    end

    test "update_picture/2 with invalid data returns error changeset" do
      picture = picture_fixture()
      assert {:error, %Ecto.Changeset{}} = Storage.update_picture(picture, @invalid_attrs)
      assert picture == Storage.get_picture!(picture.id)
    end

    test "delete_picture/1 deletes the picture" do
      picture = picture_fixture()
      assert {:ok, %Picture{}} = Storage.delete_picture(picture)
      assert_raise Ecto.NoResultsError, fn -> Storage.get_picture!(picture.id) end
    end

    test "change_picture/1 returns a picture changeset" do
      picture = picture_fixture()
      assert %Ecto.Changeset{} = Storage.change_picture(picture)
    end
  end
end
