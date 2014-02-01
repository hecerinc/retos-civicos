require 'spec_helper'
require 'carrierwave/test/matchers'

feature "Submit an app" do
  include CarrierWave::Test::Matchers

  let!(:member) { FactoryGirl.create(:user).userable }
  let!(:organization) { FactoryGirl.create(:user, userable: Organization.new).userable }
  let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }

  background do
    sign_in_user(member.user, password: 'password')
    FactoryGirl.create(:collaboration, member: member, challenge: challenge)
  end

  scenario "Create and submit app" do
    visit new_challenge_entry_path(challenge.id)

    within '#new_entry' do
      fill_in 'entry[name]', with: 'App de Prueba'
      fill_in 'entry[description]', with: 'Spec de subir una app'
      fill_in 'entry[github_url]', with: 'https://github.com/CodeandoMexico/aquila'
      fill_in 'entry[live_demo_url]', with: 'http://codeandomexico.org'
      attach_file('entry[entry_logo]',"#{Rails.root}/spec/images/happy-face.jpg")
      fill_in 'entry[team_members]', with: 'yo, y los demas'
      click_button 'Enviar proyecto'
    end

    within '#pitch' do
      page.should have_content 'App de Prueba'
      page.should have_content 'Spec de subir una app'
      page.should have_content 'https://github.com/CodeandoMexico/aquila'
      page.should have_content 'http://codeandomexico.org'
      page.should have_content 'yo, y los demas'
    end

    click_link 'Ir al reto - El titulo 1'

    within '.tabs' do
      page.should have_content '1 Apps'
    end

    click_link '1 Apps'

    within '#entriesTTab' do
      page.should have_content 'App de Prueba'
      page.should have_content 'Spec de subir una app'
      page.should have_link 'Repo', 'https://github.com/CodeandoMexico/aquila'
      page.should have_link 'Demo', 'http://codeandomexico.org'
    end

    #borrar imagen y folders creados
    FileUtils.rm_rf(Dir["#{Rails.root}/public/entries_logo/entry/entry_logo/1"])
  end

end
