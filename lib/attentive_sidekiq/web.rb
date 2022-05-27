module AttentiveSidekiq
  module Web
    VIEW_PATH = File.expand_path("../web/views", __FILE__)

    def self.registered(app)
      app.get("/disappeared-jobs") do
        @disappeared_jobs = AttentiveSidekiq::Disappeared.jobs
        @total_size = @disappeared_jobs.size

        erb File.read(File.join(VIEW_PATH, 'disappeared-list.erb'))
      end

      app.post("/disappeared-jobs") do
        pp params
        params["key"]&.each do |jid|
          pp jid
          if params["retry"]
            AttentiveSidekiq::Disappeared.requeue(jid)
          elsif params["delete"]
            AttentiveSidekiq::Disappeared.remove(jid)
          end
        end
        redirect "#{root_path}disappeared-jobs"
      end
      
      app.get("/disappeared-jobs/:key") do
        @job = AttentiveSidekiq::Disappeared.get_job params[:key]
        redirect "#{root_path}disappeared-jobs" if @job.nil?

        erb File.read(File.join(VIEW_PATH, "disappeared-detail.erb"))
      end

      app.post("/disappeared-jobs/requeue-all") do
        AttentiveSidekiq::Disappeared.jobs.each do |job|
          if job['status'] == AttentiveSidekiq::Disappeared.STATUS_DETECTED
            AttentiveSidekiq::Disappeared.requeue(job['jid'])
          end
        end
        redirect "#{root_path}disappeared-jobs"
      end

      app.post("/disappeared-jobs/delete-all") do
        AttentiveSidekiq::Disappeared.jobs.each do |job|
          AttentiveSidekiq::Disappeared.remove(job['jid'])
        end
        redirect "#{root_path}disappeared-jobs"
      end

      app.post("/disappeared-jobs/:jid/delete") do
        AttentiveSidekiq::Disappeared.remove(params['jid'])
        redirect "#{root_path}disappeared-jobs"
      end

      app.post("/disappeared-jobs/:jid/requeue") do
        AttentiveSidekiq::Disappeared.requeue(params['jid'])
        redirect "#{root_path}disappeared-jobs"
      end
    end
  end
end

Sidekiq::Web.register AttentiveSidekiq::Web
Sidekiq::Web.locales << File.expand_path(File.dirname(__FILE__) + "/web/locales")
Sidekiq::Web.tabs['disappeared_jobs'] = 'disappeared-jobs'
