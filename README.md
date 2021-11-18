## Crew

A web application which lists all members of a product team and let users cast their vote.

### Problem Statement
Create a roster page for the G2 Crowd product team, with voting functionality to let people share their excitement!

Render the attached layout, based on data found at this CORS enabled endpoint:

https://coding-assignment.g2crowd.com

Assume that the results of the API are dynamic. So for instance if we were to hire a new engineer, then the API would return an additional listing.

The voting widget on each listing should be functional, meaning:

* As a visitor to the site, I can see how many times each listing has been voted on by other visitors
* As a visitor to the site, when I vote for a team member, then the number of votes should be incremented, and the voting widget should reflect that I voted

### Technical Overview
```
MacOS Big Sur v11.6
ruby '3.0.2'
gem 'rails', '~> 6.1.4'
gem 'pg', '1.2.3'                         # Used for Database
gem 'devise', '4.8.0'                     # Used for authentication purpose
gem 'bootstrap', '5.1.0'                  # Used for responsive UI components
gem 'que', '0.14.3'                       # Used as Background Job service
gem 'open-uri', '0.1.0'                   # Used for reading data from CORS endpoint
gem 'config', '3.1.0'                     # Used for configuring settings.yml
gem 'rspec-rails', '5.0.2'                # Used for UAT test cases
gem 'factory_bot_rails', '6.2.0'          # Used as test helper methods
gem 'faker', '2.19.0'                     # Used for generating fake test data
```
- Using `rvm` as the Ruby Version Manager.
- Using `font-awesome` minified css stylesheet for icons.

### Implementation Overview
- Background Jobs to read data from external links
- Ajax based calls to render the partial views
- Bootstrap theme for look and feel
- CSS for styling DOM elements
- Added `db:seed`
- Added Rspec Controller & Model tests for UAT
- DRY principle is followed to keep the code clean and readable(with comments)

### Steps to setup and run the project on Mac
- Unzip crew.zip and cd into the directory
```
  cd crew
```
- Install and Switch to Ruby v3.0.2
```
  rvm install ruby-3.0.2 (Optional)              # If not already installed
  rvm use ruby-3.0.2
``` 
- bundle
```
  bundle install
```
- Install Postgresql
```
  brew install postgresql (Optional)             # If not already installed
```
- Create database and run migrations
```
  rails db:create db:migrate db:seed             # Seed to load members from external link
```
- Start Que workers(default 6) in a new Terminal Window/Tab
```
  rvm use ruby-3.0.2                             # Make sure the new tab/window is using required ruby version
  que ./config/environment.rb                    # call 'Que.job_stats' to view jobs currently in the queue
```
- Start the server
```
  rails server
```

### Functional Overview
- Visit `localhost:3000` in your browser. Member listing page will be displayed.
- Visitors can only view Member information. Inorder to cast a vote one must sign up and sign in.
- Vote widget captures every user vote and doesn't encourage duplicate/proxy votes.

### Steps to run Rspec tests
- Create database and run migrations (Skippable step)
```
  RAILS_ENV=test rails db:create db:migrate (Optional)
```
- Execute `Rspec` tests
```
  rspec spec/ --format documentation
```

**Note**: To reset the DB, please make sure you stop all services such as `rails server`, `que`, `rails console`, etc.

### Functional Details
- Visitor must have an identity to cast a vote. Hence he/she should have an User account first
  - Only the `vote` action requires authentication
  - Vote table holds a foreign key references to Member & User table
  - A unique DB constraint ensures that no identical entries exist for a vote model

- Members are fetched from external link and stored into DB table using Background Job
  - [`Que`](https://github.com/que-rb/que) a Postgres backed job queue is used
  - LoadMembersJob:
    - Invoked in `db:seed` and `Members#index` action
    - Marks member as inactive whose information is missing in the latest fetch
    - Members#index action always returns active list of members
  - AttachImageJob:
    - Uploads/Attach image to a Member record
    - Invoked for every member record that is newly created
    - Job will be triggered only if the profile image attachment is missing
  - All DB operations are wrapped inside the DB.Transaction within begin..rescue block

- Members listing page with voting functionality
  - View partials are rendered for an active member collection object
  - Casting a vote renders just the `_vote.html.erb` partial through successful Ajax calls
  - Expired session, duplicate/proxy votes are all redirected to listing page with appropriate error message

- Others
  - Validations and Callbacks are in place
  - Currently Member CRUD routes are disabled. Can be enabled as an extension to create and manage members in system
  - `belongs_to :member` has `counter_cache: true` statement that auto increments the votes_count column value of Member table
  - Bootstrap classes were used to add header navbar, footer navbar, card layout for listing members, sign up/sign in form, vote form, buttons/links, alert notifications, etc.
  - Devise is configured to whitelist Name attribute for registration
  - Configured [`Settings.yml`](https://github.com/rubyconfig/config) file for CORS endpoint declaration
  - `InvalidAuthenticityToken` & `CSRF attacks` are prevented and handled
