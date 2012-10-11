class Affiliates::SocialMediaController < Affiliates::AffiliatesController
  PROFILE_TYPES = %w(FacebookProfile FlickrProfile TwitterProfile YoutubeProfile).freeze
  before_filter :require_affiliate_or_admin
  before_filter :setup_affiliate, :except => [:new_profile_fields]
  before_filter :validate_profile_type, :except => [:index]

  def index
    if params[:profile_type].present? and PROFILE_TYPES.include?(params[:profile_type])
      @profile = Object::const_get(params[:profile_type]).new
    end
  end

  def create
    @profile =
        case params[:profile_type]
        when 'TwitterProfile'
          TwitterProfile.where(:screen_name => params[:social_media_profile][:screen_name]).first_or_create
        when 'FacebookProfile', 'FlickrProfile', 'YoutubeProfile'
          @affiliate.send(:"#{params[:profile_type].underscore}s").build(params[:social_media_profile])
        end

    if @profile.new_record?
      unless @profile.save
        render(:action => :index) and return
      end
    else
      @affiliate.twitter_profiles << @profile unless @affiliate.twitter_profiles.exists?(@profile)
    end
    case @profile.class.name
    when 'TwitterProfile' then @affiliate.update_attributes!(:is_twitter_govbox_enabled => true)
    when 'FlickrProfile' then @affiliate.update_attributes!(:is_photo_govbox_enabled => true)
    when 'YoutubeProfile' then @affiliate.rss_feeds.managed.first.update_attributes!(:shown_in_govbox => true)
    end
    flash[:success] = "Added #{@profile.class.name.titleize}"
    redirect_to affiliate_social_media_path(@affiliate)
  end

  def destroy
    if params[:profile_type] == 'TwitterProfile'
      profile = TwitterProfile.find(params[:id])
      @affiliate.twitter_profiles.delete(profile)
    else
      profile = @affiliate.send(:"#{params[:profile_type].underscore}s").find(params[:id]).destroy
    end
    flash[:success] = "#{profile.class.name.titleize} successfully deleted"
    redirect_to affiliate_social_media_path(@affiliate)
  end

  def preview
    @recent_social_media = @affiliate.
        send(:"#{params[:profile_type].underscore}s").
        find(params[:id]).
        recent
    @page_title = case params[:profile_type]
                  when 'FlickrProfile' then 'Recent Flickr photos'
                  when 'TwitterProfile' then 'Recent tweets'
                  when 'YoutubeProfile' then 'Recent YouTube videos'
                  end
  end

  def new_profile_fields
    request.format = :js
    render "new_#{params[:profile_type].underscore}_fields"
  end

  def validate_profile_type
    redirect_to affiliate_social_media_path(@affiliate) unless PROFILE_TYPES.include?(params[:profile_type])
  end
end
