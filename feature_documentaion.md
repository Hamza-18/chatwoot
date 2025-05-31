# Chatwoot Feature Enhancement

## Task 1: Custom Branding Integration
### Custom Logo and theme
-   **Inspect the rendered HTML in the browser’s developer tools.**  
	By inspecting the HTML file I could easily find the tags which were responsible for each logo and it helped me narrow down my search in the code base.
-   **Trace how the “logo” is injected into the page.**  
    I discovered that the HTML doesn’t hard-code a file path; instead, it looks up a “logo” value from the database via a Global Config object in the Dashboard controller.
-   **Confirm which database rows store the logo path.**  
    In the `installation_configs` table, there are three separate serialized fields for “brand logo”. To verify, I opened Rails console and checked that those three rows each contained a serialized file path.
-   **Write a migration to update each row.**  
    Finally, I generated a Rails migration that changes the serialized path for all three “brand logo” entries to point at my custom image. Once the migration ran, the new logo appeared correctly (for both light and dark modes) without modifying any HTML directly.
- **Update icon for browser tab.**
	After running the migration, I noticed that the browser tab Icon was not changed. Upon checking the code, I found that it would first fetch the icon from hard coded path and then from the database if it failed. So I changed the priority to use global config first.
	``` ruby
	class UpdateLogoConfig < ActiveRecord::Migration[7.1]
	  def up
	    # Update the logo configurations to point to the new custom logo path
	    %w[LOGO_THUMBNAIL LOGO LOGO_DARK].each do |name|
	      config = InstallationConfig.find_by(name: name)
	      next unless config

	      # Update the serialized value to point to the new custom logo path using with_indifferent_access
	      config.serialized_value = { value: '/brand-assets/custom_logo.svg' }.with_indifferent_access
	      config.save!
	    end

	    GlobalConfig.clear_cache if defined?(GlobalConfig)
	  end
	end
	```
	![alt text](<Screenshot from 2025-05-31 15-11-45.png>)
- **Updating the Theme.**
  I used DevTools to inspect the CSS selector, then jumped straight to that spot in the code base. Found three files responsible for the theme _variables.scss, _next-colors.css, _woot.scss
- **_next-colors.scss**  
  This file defines Chatwoot’s core color palette using CSS variables. The `--slate-*` series provides neutral grays (from very dark to very light), and the `--iris-*` series provides the primary accent hues (a purplish-blue scale). Components throughout the app reference these variables (e.g. `var(--slate-5)` for a mid-tone gray or `var(--iris-7)` for an accent color), ensuring consistent theming and easy dark/light mode support.

  **Why it matters:**  
  - Centralizes all neutral (“slate”) and accent (“iris”) RGB values in one place.  
  - Changing any `--slate-*` or `--iris-*` value immediately updates every component that uses it—no need to hunt for scattered hex codes.  
  - Enables seamless dark/light toggling by redefining the same variables in a `.dark` block.

  **How I updated the theme:**  
  1. Reviewed the existing `--slate-*` and `--iris-*` RGB triples (e.g., `--slate-1: 17 17 19;`, `--iris-5: …;`).  
  2. Chose new RGB values to slightly lighten the grays and shift the accent blues to a cooler tone (e.g., changed `--slate-1: 17 17 19;` → `20 24 28;` and `--iris-3: 32 34 72;` → `23 28 97;`).  

- **_woot.scss**  
  This file defines Chatwoot’s primary “brand” color scale via a series of CSS variables named `--color-primary-25`, `--color-primary-50`, … up to `--color-primary-900`. Whenever the UI needs to draw attention—buttons, tags, focus rings, active icons, links, or any call-to-action—it pulls from one of these “primary” variables. By centralizing all primary-color RGB values here, you ensure that every accent element in Chatwoot shares the same underlying hue and lightness progression.

  **Why it matters:**  
  - **Consistent brand tone.** Instead of hard coding theme colors in each scss file, main theme is defined here.
  - **Easier theming.** In order to change the brand theme, you just need to update the  `--color-primary-*` .  
  - **Semantic shading.** Each step in the scale (`25 → 900`) has a meaningful role: very dark backgrounds, main base tone, hover/tags, active icons, focus rings, or the lightest tint for contrast text/backgrounds. Having numbered steps makes it straightforward to know “which shade is right” based on context.

  **How I updated the `--color-primary-*` palette:**  
  1. **Removed the old RGB triples.**  
     The original variables looked like this:  
     ```diff
     - --color-primary-25: 10 17 28;
     - --color-primary-50: 15 24 38;
     - --color-primary-75: 15 39 72;
     - --color-primary-100: 10 49 99;
     - --color-primary-200: 18 61 117;
     - --color-primary-300: 29 74 134;
     - --color-primary-400: 40 89 156;
     - --color-primary-500: 48 106 186;
     - --color-primary-600: 39 129 246;
     - --color-primary-700: 21 116 231;
     - --color-primary-800: 126 182 255;
     - --color-primary-900: 205 227 255;
     ```
     These steps produced a range from a very dark bluish-gray up to a pale, nearly white blue.

  2. **Chose new RGB values with context comments.**  
     I replaced each line with a new triple and added a short comment describing its intended use. For example:  
     ```diff
     /* very dark → deep slate-blue → strong presence → subtle bluish-gray → etc. */
     + --color-primary-25:  14 22 30;   // Very dark bluish-gray
     + --color-primary-50:  20 30 40;   // Deep slate-blue
     + --color-primary-75:  30 44 60;   // Stronger presence, still background-suitable
     + --color-primary-100: 40 58 80;   // Subtle blue-gray
     + --color-primary-200: 52 74 103;  // Steel indigo
     + --color-primary-300: 66 94 128;  // Main base tone
     + --color-primary-400: 84 118 158; // Primary accent shade
     + --color-primary-500: 102 140 184; // Button hover / tags
     + --color-primary-600: 118 158 206; // Active icons / highlights
     + --color-primary-700: 138 178 229; // Soft call to action
     + --color-primary-800: 168 204 255; // Borders / focus ring
     + --color-primary-900: 210 232 255; // Lightest tint for contrast text or backgrounds
     ```
     By annotating each step with its purpose (e.g., “Button hover / tags,” “Active icons / highlights,” “Borders / focus ring,” etc.), it becomes immediately clear which shade to reference in a given component or variant.
- **_variables.scss (Administrate library)**  
  This file defines core UI variables used by the Administrate dashboard. In this change, the `$grey-0` variable was updated from a light gray (`#f6f7f7`) to a teal-ish shade (`#12d9d9`), instantly shifting any component or background that relies on `$grey-0` without touching individual styles.
  ![alt text](<Screenshot from 2025-05-31 15-12-30.png>)

### Replacing Captain and Assistant
This task requires refactoring of the whole code base and database to replace captain with ai agent and assistant with topic.
-   **Migrate Database tables.**
	Created migration file to rename which contain the keyword captain and assistant in either table name, column, and index.
	```
	class MigrateCaptainToAiAgent < ActiveRecord::Migration[7.1]
		  def up
		    rename_table :captain_assistant_responses, :ai_agent_topic_responses

		    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_account_id"
		    add_index :ai_agent_topic_responses, :account_id, name: "index_ai_agent_topic_responses_on_account_id"

		    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_assistant_id"
		    add_index :ai_agent_topic_responses, :account_id, name: "index_ai_agent_topic_responses_on_assistant_id"

		    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_status"
		    add_index :ai_agent_topic_responses, :account_id, name: "index_ai_agent_topic_responses_on_status"

		  end

		  def down
		    rename_table :ai_agent_topic_responses, :captain_assistant_responses

		    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_account_id"
		    add_index :captain_assistant_responses, :account_id, name: "index_captain_assistant_responses_on_account_id"

		    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_assistant_id"
		    add_index :captain_assistant_responses, :account_id, name: "index_captain_assistant_responses_on_assistant_id"

		    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_status"
		    add_index :captain_assistant_responses, :account_id, name: "index_captain_assistant_responses_on_status"
		  end

		end
	```
-   **Rename file path and directories.**
		I wrote a Python script that uses the `os` module to traverse a root directory and rename every file and folder. Since different parts of the codebase follow different naming conventions (snake_case, PascalCase, camelCase), the script detects each naming style and converts it to the desired format when renaming.
	```python3
	import  os
	def  rename_captain_assistant_file_path():
		for  root, dirs, files  in  os.walk(".", topdown=True):
			# Skip unwanted directories
			dirs[:] = [d  for  d  in  dirs  if  d  not  in ["node_modules", "circleci", "dependabot",".devcontainer",".github", ".husky", ".vscode",".windsurf", "bin"]]
			for  file  in  files:
				old_file_path  =  os.path.join(root, file)
				keywords  = [("captain", ("aiAgent", "ai_agent","ai-agent")), ("assistant", ("topic","topic","topic")),("Captain",("AiAgent")), ("Assistant", ("Topic"))]

				new_file_name  =  file
				renamed  =  False
				for  i  in  range(len(keywords)):
					old  =  keywords[i][0]
					new  =  keywords[i][1]
					if  old  in  new_file_name:
						if  old.islower() and  old  in  new_file_name:
							index  =  new_file_name.lower().index(old)
							next_index  =  len(old) +  index
							if  next_index  <  len(new_file_name):
								if  new_file_name[next_index].isupper():
									new_file_name  =  new_file_name.replace(old, new[0])
								elif  new_file_name[next_index] ==  "_":
									new_file_name  =  new_file_name.replace(old, new[1])
								else:
									new_file_name  =  new_file_name.replace(old, new[2])
								else:
									new_file_name  =  new_file_name.replace(old, new[1])
									renamed  =  True
							elif  old  in  new_file_name:
								new_file_name  =  new_file_name.replace(old, new)
								renamed  =  True
					if  renamed:
						new_file_path  =  os.path.join(root, new_file_name)
						print(f"FILE Renamed '{old_file_path}' to '{new_file_path}'")
						os.rename(old_file_path, new_file_path)
		# Rename directories
		for  dir  in  dirs:
			dir_keywords  = [("captain","ai_agent"),("assistant", "topic")]
			old_dir_path  =  os.path.join(root, dir)
			new_dir_name  =  dir
			renamed  =  False
			for  old, new  in  dir_keywords:
			if  old  in  new_dir_name:
			new_dir_name  =  new_dir_name.replace(old, new)
			renamed  =  True
			if  renamed:
				new_dir_path  =  os.path.join(root, new_dir_name)
				print(f"Renaming directory '{old_dir_path}'")
				os.rename(old_dir_path, new_dir_path)

				print(f"Renamed to '{new_dir_path}'")
			
	if  __name__  ==  "__main__":
		rename_captain_assistant_file_path()
	```
- **Rename Captain.**
I used Vs Code advanced search to replace all the instances of the captain keyword, based on the naming convention used in different files. 
***Patterns that I found:***
	1) ``captain/`` -> ``ai_agent/``
	2) ``/captain`` -> ``/ai-agent ``
	3) ``captain-`` -> ``ai-agent-``
	4) ``-captain`` -> ``-ai-agent``
	5) `` Captain`` -> ``AiAgent``
	6) ``captain(?=[A-Z])`` -> ``aiAgent``
	7) ``captain:``-> ``ai_agent:``
	8)  ``_captain`` -> `` _ai_agent``
	9) ``captain_`` -> ``ai_agent_``
- **Rename Assistant.**
Since Assistant is a single word so I didn't have to consider different type of naming conventions and there were only two patterns:
	1) ``assistant`` -> ``topic``
	2) ``Assistant``  -> ``Topic``

	![alt text](<Screenshot from 2025-05-31 15-14-05.png>)

	![alt text](<Screenshot from 2025-05-31 15-14-27.png>)