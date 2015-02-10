#/bin/bash

### Constants ###

DIR_DROPBOX_HOME="$HOME/Dropbox/home"
# HOME="$HOME/link-test"; mkdir -p "$HOME" # DEBUG ONLY
DIR_BACKUP="$HOME/.BackupDropboxHomeLinks/$(date +%Y%m%d_%H%M%S)"


### Functions ###

prune_dir () {
	echo "Cleaning up (or creating) directory $1"
	rm -rf "$1"
	mkdir -p "$1"
}


create_dir () {
	echo "Creating or reusing directory $1"
	mkdir -p "$1"
}


change_dir () {
	local new_dir="$1"
	local current_dir="$(pwd)"

	if [ "$new_dir" != "$current_dir" ]; then
  		echo "Changing directory to $new_dir"
  		mkdir -p "$new_dir"
		cd "$new_dir"
	fi
}


link () {
	local source_dir="$1"
	local destination_dir="$2"
	local backup_dir="$3"
	local file_name="$4"
	# echo "link($source_dir, $destination_dir, $backup_dir, $file_name)"
	local cd_return="$(pwd)"
	

	change_dir "$destination_dir"
	mkdir -p "$backup_dir" # make sure it exists 
	# If source is a symbolic link, it's already reverse-linked
	if [[  -L "$source_dir/$file_name" ]]; then	
		echo "Skipping $file_name, already reverse-linked."
	# Make sure that source exists
	elif [[ ! -e "$source_dir/$file_name" || ! -d "$source_dir/$file_name" ]]; then
		echo "WARNING: $source_dir/$file_name does not exist."
	else
		if [[ -d "$file_name" ]]; then
    		echo "Backing up contents of $file_name"
    		mkdir -p "$backup_dir/$file_name"
    		mv "$file_name"/* "$backup_dir/$file_name"
		elif [[ -e "$file_name" || -L "$file_name" ]]; then
			echo "Backing up file $file_name"
    		mv "$file_name" "$backup_dir"
		fi
		mv "$source_dir/$file_name" .
		cd "$source_dir"; ln -s "$destination_dir/$file_name" .; cd "$destination_dir"
		echo "$destination_dir/$file_name reverse-linked."
	fi

	change_dir "$cd_return"
}


link_contents () {
	local source_dir="$1";
	local destination_dir="$2";
	local backup_dir="$3"
	local dir_name="$4"
	# echo "link_contents($source_dir, $destination_dir, $backup_dir, $dir_name)"
	local cd_return="$(pwd)"

	echo "Linking contents of dir $destination_dir/$dir_name..."
	change_dir "$destination_dir/$dir_name"
	for entry in "$source_dir/$dir_name"/*
	do
		local file_name="${entry##*/}"
  		link "$source_dir/$dir_name" "$destination_dir/$dir_name" "$backup_dir/$dir_name" "$file_name"
	done

	change_dir "$cd_return"
}


### START MAIN ###

echo "Linking Dropbox to home dir..."
echo "Dropbox home directory: $DIR_DROPBOX_HOME"
echo "Home dir: $HOME"
echo "Backup directory: $DIR_BACKUP"

echo ""
read -p "WARNING: This will replace all local files with dropbox... Press any key to continue or CTRL-C to abort"

change_dir "$HOME"

# Create DIR_Backup dirs
prune_dir "$DIR_BACKUP"

### START LINKING ###

change_dir ~
link "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" ".bash_profile"
link "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" ".bash_history"
link "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" ".gitconfig"
link "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" ".s3cfg"
link_contents "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" ".ssh"
link "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" ".vimrc"
link "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" "bin"

link_contents "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" "Applications"
link "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" "Development"
link "$DIR_DROPBOX_HOME" "$HOME" "$DIR_BACKUP" "Documents"

link "$DIR_DROPBOX_HOME/Library" "$HOME/Library" "$DIR_BACKUP/Library" "Mail"
link "$DIR_DROPBOX_HOME/Library" "$HOME/Library" "$DIR_BACKUP/Library" "Messages"
link_contents "$DIR_DROPBOX_HOME/Library" "$HOME/Library" "$DIR_BACKUP/Library" "LaunchAgents"
link_contents "$DIR_DROPBOX_HOME/Library" "$HOME/Library" "$DIR_BACKUP/Library" "Application Support"
link_contents "$DIR_DROPBOX_HOME/Library" "$HOME/Library" "$DIR_BACKUP/Library" "Preferences"
link_contents "$DIR_DROPBOX_HOME/Library" "$HOME/Library" "$DIR_BACKUP/Library" "Containers"

echo "Check everything is ok and then restart..."