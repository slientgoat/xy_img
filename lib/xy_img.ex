defmodule XyImg do
  @moduledoc """
  在phoenix `priv/static/images/xxx/目录`下生成图片.
  """

  def expires, do: Application.get_env(:xy_img, :expires) #图片存在时长
  def path, do: Application.get_env(:xy_img, :path, "images/xy_img") #static图片存放目录
  def phx_name, do: Application.get_env(:xy_img, :phx_name) || :xy_img #phoenix项目名称

  @doc """
  图片存放路径.
  """
  def save_path() do
    appdir = Application.app_dir(phx_name())
    save_dir = Path.join([appdir, "priv/static", path()])
    File.exists?(save_dir) || File.mkdir_p!(save_dir)
    save_dir
  end

  @doc """
  图片的物理路径
  """
  def file_path(filename), do: Path.join([save_path(), filename])

  @doc """
  图片的Phoenix.Endpoint.url路径
  """
  def file_url(filename, url \\ ""), do: Path.join([url, path(), filename])


  @doc """
  删除priv/static/images/xxx/xxx.png文件。
  """
  def del_file(filename), do: File.rm(file_path(filename))

  @doc """
  删除static/xxx目录。
  """
  def del_all() do
    File.rm_rf(save_path())
    File.exists?(save_path()) || File.mkdir_p!(save_path())
  end

  @doc """
  创建多媒体文件。
  """
  def create("image/" <> _ = type, data_bin), do: create_img(type, data_bin)
  def create("video/" <> _ = type, data_bin), do: create_video(type, data_bin)

  @doc """
  创建图片。
  """
  def create_img("image/jpeg", data_bin), do: do_create(expires(), data_bin, ".jpg")
  def create_img("image/png", data_bin), do: do_create(expires(), data_bin, ".png")
  def create_img("image/gif", data_bin), do: do_create(expires(), data_bin, ".gif")
  def create_img(_unknow_support_type, _data_bin), do: {:error, :unknow_support_type}

  @doc """
  创建视频。
  """
  def create_video("video/mp4", data_bin), do: do_create(expires(), data_bin, ".mp4")
  def create_video("video/mkv", data_bin), do: do_create(expires(), data_bin, ".mkv")
  def create_video("video/avi", data_bin), do: do_create(expires(), data_bin, ".avi")
  def create_video(_unknow_support_type, _data_bin), do: {:error, :unknow_support_type}

  defp do_create(nil, data_bin, postfix) do
    filename = UUID.uuid4(:hex) <> postfix
    File.write!(file_path(filename), data_bin)
    {:ok, filename}
  end
  defp do_create(expires_time, data_bin, postfix) do
    {:ok, filename} = do_create(nil, data_bin, postfix)
    spawn(
      fn () ->
        Process.sleep(expires_time)
        del_file(filename)
      end
    )
    {:ok, filename}
  end

end
