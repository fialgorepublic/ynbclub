namespace :organizations do
  task migrate_to_active_storage: :environment do
    Blog.where.not(avatar_file_name: nil).find_each do |blog|
      logo_url = "https://s3.amazonaws.com/saintalgorepublic/files/original/#{blog.id}_#{blog.avatar_file_name}"
      blog.avatar.attach(io: open(logo_url),
                                   filename: blog.avatar_file_name,
                                   content_type: blog.avatar_content_type)
    end

    puts "Importing Page images"
    Page.where.not(image_file_name: nil).find_each do |page|
      logo_url = "https://s3.amazonaws.com/saintalgorepublic/files/original/#{page.id}_#{page.image_file_name}"
      page.image.attach(io: open(logo_url),
                                   filename: page.image_file_name,
                                   content_type: page.image_content_type)
    end

    puts "Importing SanpShot images"
    Snapshot.where.not(step1_avatar_file_name: nil).find_each do |page|
     logo_url = "https://s3.amazonaws.com/saintalgorepublic/files/original/#{page.id}_#{page.step1_avatar_file_name}"
      page.step1_avatar.attach(io: open(logo_url),
                                   filename: page.step1_avatar_file_name,
                                   content_type: page.step1_avatar_content_type)
    end

    Snapshot.where.not(step2_avatar_file_name: nil).find_each do |page|
      logo_url = "https://s3.amazonaws.com/saintalgorepublic/files/original/#{page.id}_#{page.step2_avatar_file_name}"
      page.step2_avatar.attach(io: open(logo_url),
                                   filename: page.step2_avatar_file_name,
                                   content_type: page.step2_avatar_content_type)
    end

    Snapshot.where.not(step3_avatar_file_name: nil).find_each do |page|

      logo_url = "https://s3.amazonaws.com/saintalgorepublic/files/original/#{page.id}_#{page.step3_avatar_file_name}"
      page.step3_avatar.attach(io: open(logo_url),
                                   filename: page.step3_avatar_file_name,
                                   content_type: page.step3_avatar_content_type)
    end

    Snapshot.where.not(step4_avatar_file_name: nil).find_each do |page|
      logo_url = "https://s3.amazonaws.com/saintalgorepublic/files/original/#{page.id}_#{page.step4_avatar_file_name}"
      page.step4_avatar.attach(io: open(logo_url),
                                   filename: page.step4_avatar_file_name,
                                   content_type: page.step4_avatar_content_type)
    end

    puts "Import user images"
    User.where.not(avatar_file_name: nil).find_each do |user|
      logo_url = "https://s3.amazonaws.com/saintalgorepublic/files/original/#{user.id}_#{user.avatar_file_name}"
      user.avatar.attach(io: open(logo_url),
                                   filename: user.avatar_file_name,
                                   content_type: user.avatar_file_name)
    end
  end
end
