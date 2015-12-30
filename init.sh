#!/bin/bash
# Sublime Text Synchronization

#### Directory Structure
# /Installed Packages/
# /Packages/
# init.sh (this script)


#### Variables
# Path to directory in Dropbox
DROPBOXFOLDER=~/Dropbox/Apps/sublime-text-3/
# Sublime Application Support Path
SUBLIMESUPPORT=~/Library/Application\ Support/Sublime\ Text\ 3/
# Sublime Text Binary Path
SUBLIMEBINARY=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl

### Functions
#
function createFolderSymlinks {
	## Prompt
	echo ""
	echo "This script will symlink your Sublime Text Packages and Installed Packages from your Dropbox to your local machine."
	read -p "Do you wish to continue? [y/n] " answer
	echo ""

	if [[ $answer = y ]]; then
		echo ""
		echo "Initializing..."
		echo ""
		sleep 1
		# Does Sublime Application Support folder exist?
		if [ -d "$SUBLIMESUPPORT" ]; then
			# Folder exists!
			# Create symlinks for folders
			if [[ ( -d "$SUBLIMESUPPORT/Packages/" ) && ( -d "$SUBLIMESUPPORT/Installed Packages/" ) ]]; then
				# Found Directories!

				# Remove the original folders
				echo "Removing original /Packages/"
				rm -rf "$SUBLIMESUPPORT/Packages" 2> /dev/null
				sleep 1
				echo "Removing original /Installed Packages/"
				echo ""
				rm -rf "$SUBLIMESUPPORT/Installed Packages" 2> /dev/null
				sleep 1

				# Test to see if folders were removed successfully
				if [[ ( -d "$SUBLIMESUPPORT/Packages" ) || ( -d "$SUBLIMESUPPORT/Installed Packages") ]]; then
					echo "Failed to remove /Packages/, aborting."
					echo ""
					exit 1
				else
					echo "Successfully removed /Packages/ and /Installed Packages/"
					sleep 2
					echo ""
					echo "Replacing with symlinks..."
					sleep 1
					# Create symlinks
					ln -s "$DROPBOXFOLDER/Packages" "$SUBLIMESUPPORT/Packages"
					ln -s "$DROPBOXFOLDER/Installed Packages" "$SUBLIMESUPPORT/Installed Packages"
					echo ""
					echo "Symlinks created successfully!"
					echo "~/Library/Application Support/Sublime Text 3/Packages/"
					echo "~/Library/Application Support/Sublime Text 3/Installed Packages/"
					echo ""
					sleep 1
				fi
			else
				# Failed to find Directories
				echo "Couldn't find /Packages/ or /Installed Packages/, aborting."
				echo "Try launching Sublime Text to create the directories."
				echo ""
				exit 1
			fi
		else
			echo "~/Library/Application Support/Sublime Text 3/ is missing. Launch Sublime Text 3 once to create the folders."
		fi
	else
		echo ""
	fi

}

function createBinarySymlink {
	if [[ -f $SUBLIMEBINARY ]]; then
		read -p "Do you want to create a symlink for the binary in /usr/local/bin? [y/n] " answer
		echo ""
		if [[ $answer = y ]]; then
			# Check if symlink already exists
			if [[ -f "/usr/local/bin/subl" ]]; then
				echo "Symlink already exists!"
				echo ""
			else
				# File doesn't exist, create it
				echo "Creating symlink /usr/local/bin/subl"
				echo ""
				# Create symlink
				ln -s "$SUBLIMEBINARY" /usr/local/bin/subl
				sleep .5
				# Check if symlink was created
				if [[ -f "/usr/local/bin/subl" ]]; then
					echo "Symlink created successfully!"
					echo "/usr/local/bin/subl"
					echo ""
				else
					echo "Failed to create symlink."
					echo ""
				fi
			fi
		else
			echo ""
			echo "Aborting."
			echo ""
			exit 1
		fi
	else
		echo "Can't find the subl binary in the Applications folder, is Sublime Text installed?"
		exit 1
	fi
}

#### Main
# Check if Sublime Text is installed
echo ""
echo ""
if [[ -d "/Applications/Sublime Text.app" ]]; then
	echo "Sublime Text is installed in /Applications/"
	echo ""
	sleep 1
	# Does Sublime Application Support folder exist?
	if [ -d "$SUBLIMESUPPORT" ]; then
		# ~/Library/Application Support/Sublime Text 3/ exists.
		# Create directory symlinks
		createFolderSymlinks
		# Create binary symlink
		createBinarySymlink
		sleep 1
		echo "Completed!"
		echo ""
	else
		echo "~/Library/Application Support/Sublime Text 3/ is missing. Launch Sublime Text 3 once to create the folders."
	fi
else
	echo "Couldn't find Sublime Text.app in /Applications/, aborting."
	echo ""
	exit 1
fi
