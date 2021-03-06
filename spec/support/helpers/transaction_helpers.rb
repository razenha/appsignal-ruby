module TransactionHelpers
  def uploaded_file
    if DependencyHelper.rails_present?
      ActionDispatch::Http::UploadedFile.new(:tempfile => "/tmp")
    else
      ::Rack::Multipart::UploadedFile.new(File.join(fixtures_dir, "/uploaded_file.txt"))
    end
  end

  def background_job_transaction(args = {})
    Appsignal::Transaction.new(
      "1",
      Appsignal::Transaction::BACKGROUND_JOB,
      Appsignal::Transaction::GenericRequest.new({
        "SERVER_NAME" => "localhost",
        "action_dispatch.routes" => "not_available"
      }.merge(args))
    )
  end

  def http_request_transaction(args = {})
    Appsignal::Transaction.new(
      "1",
      Appsignal::Transaction::HTTP_REQUEST,
      Appsignal::Transaction::GenericRequest.new({
        "SERVER_NAME" => "localhost",
        "action_dispatch.routes" => "not_available"
      }.merge(args))
    )
  end

  # Use when {Appsignal::Transaction.clear_current_transaction!} is stubbed to
  # clear the current transaction on the current thread.
  def clear_current_transaction!
    Thread.current[:appsignal_transaction] = nil
  end
end
