import os

def rename_captain_assistant_file_path():
    for root, dirs, files in os.walk(".", topdown=True):
        # Skip unwanted directories
        dirs[:] = [d for d in dirs if d not in  ["node_modules", "circleci", "dependabot",".devcontainer",".github", ".husky", ".vscode",".windsurf", "bin"]]
        for file in files:
            old_file_path = os.path.join(root, file)
            keywords = [("captain", ("aiAgent", "ai_agent","ai-agent")), ("assistant", ("topic","topic","topic")),("Captain",("AiAgent")), ("Assistant", ("Topic"))]
            new_file_name = file
            renamed = False
            for i in range(len(keywords)):
                old = keywords[i][0]
                new = keywords[i][1]
                if old in new_file_name:
                    if old.islower() and old in new_file_name:
                        index = new_file_name.lower().index(old)
                        next_index = len(old) + index
                        if next_index < len(new_file_name):
                            if new_file_name[next_index].isupper():
                                new_file_name = new_file_name.replace(old, new[0])
                            elif new_file_name[next_index] == "_":
                                new_file_name = new_file_name.replace(old, new[1])
                            else:
                                new_file_name = new_file_name.replace(old, new[2])
                        else:
                            new_file_name = new_file_name.replace(old, new[1])
                        renamed = True
                    elif old in new_file_name:
                        new_file_name = new_file_name.replace(old, new)
                        renamed = True
            if renamed:
                new_file_path = os.path.join(root, new_file_name)
                print(f"FILE Renamed '{old_file_path}' to '{new_file_path}'")
                os.rename(old_file_path, new_file_path)

         # Rename directories
        for dir in dirs:
            dir_keywords = [("captain","ai_agent"),("assistant", "topic")]
            old_dir_path = os.path.join(root, dir)
            new_dir_name = dir
            renamed = False
            for old, new in dir_keywords:
                if old in new_dir_name:
                    new_dir_name = new_dir_name.replace(old, new)
                    renamed = True
            if renamed:

                new_dir_path = os.path.join(root, new_dir_name)
                print(f"Renaming directory '{old_dir_path}'")

                os.rename(old_dir_path, new_dir_path)
                print(f"Renamed to '{new_dir_path}'")

if __name__ == "__main__":
    rename_captain_assistant_file_path()
