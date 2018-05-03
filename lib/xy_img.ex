defmodule XyImg do
  @moduledoc """
  在phoenix `priv/static/images/xxx/目录`下生成图片.
  """

  @expires Application.get_env(:xy_img, :expires) #图片存在时长
  @phx_name Application.get_env(:xy_img, :phx_name) || :xy_img #phoenix项目名称
  @path Application.get_env(:xy_img, :path) || "xy_img" #图片存放根目录


  @doc """
  图片存放路径.

  ## Examples

      iex>  XyImg.save_path
      :world

  """
  def save_path() do
    appdir = Application.app_dir(@phx_name)
    save_dir = "#{appdir}/priv/static/images/#{@path}"
    File.exists?(save_dir) || File.mkdir_p!(save_dir)
    save_dir
  end

  @doc """
  图片的物理路径

  ## Examples

      iex>  XyImg.file_url("xxx.png")
      :world

  """
  def file_path(filename), do: "#{save_path()}/#{filename}"

  @doc """
  图片的Phoenix.Endpoint.url路径

  ## Examples

      iex>  XyImg.file_url("xxx.png")
      :world

  """
  def file_url(filename, url \\ nil), do: "#{url}/images/#{@path}/#{filename}"


  @doc """
  删除priv/static/images/xxx/xxx.png文件。

  ## Examples

      iex>  XyImg.del_file("xxx.png")
      :world

  """
  def del_file(filename), do: File.rm(file_path(filename))

  @doc """
  删除priv/static/images/xxx/所有文件。

  ## Examples

      iex>  XyImg.del_all()
      :world

  """
  def del_all() do
    File.rm_rf(save_path())
    File.exists?(save_path()) || File.mkdir_p!(save_path())
  end


  @doc """
  创建图片。

  ## Examples

      iex>  XyImg.create_img("image/png","xxx")
      :world

  """
  def create_img("image/jpeg", data_bin) do
    do_create_img(@expires, data_bin, ".jpg")
  end
  def create_img("image/png", data_bin) do
    do_create_img(@expires, data_bin, ".png")
  end
  def create_img("image/gif", data_bin) do
    do_create_img(@expires, data_bin, ".gif")
  end
  def create_img(_unknow_support_type, _data_bin) do
    {:error, :unknow_support_type}
  end
  defp do_create_img(nil, data_bin, postfix) do
    filename = UUID.uuid4(:hex) <> postfix
    File.write!(file_path(filename), data_bin)
    {:ok, filename}
  end
  defp do_create_img(expires, data_bin, postfix) do
    {:ok, filename} = do_create_img(nil, data_bin, postfix)
    spawn(
      fn () ->
        Process.sleep(expires)
        del_file(filename)
      end
    )
    {:ok, filename}
  end
end
