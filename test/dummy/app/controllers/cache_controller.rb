class CacheController < ApplicationController
  def create_entries
    Rails.cache.write("demo:greeting", "Hello from Solid Cache!")
    Rails.cache.write("demo:visitors", 42)
    Rails.cache.write("demo:settings", {theme: "blue", dashboard: true})

    redirect_to root_path, notice: "Sample cache entries created."
  end

  def clear
    Rails.cache.clear

    redirect_to root_path, notice: "Cache cleared."
  end
end
