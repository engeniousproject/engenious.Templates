prereleases="true"
global_rematch() {
    declare -n ret=$3
    local s=$1 regex=$2 
    while [[ $s =~ $regex ]]; do 
        ret="${BASH_REMATCH[1]}"
        s=${s#*"${BASH_REMATCH[1]}"}
    done

}
get_latest_version() {
    declare -n ret=$3
    package_id=$1
    prereleases=$2
    versions=d$(wget --compression=auto -qO- "https://api-v2v3search-0.nuget.org/autocomplete?id=$package_id&prerelease=$prereleases")
    pat='\"([^"]*)\"' # last part encased in quotation marks

    global_rematch "$versions" "$pat" result

    ret="$result"
}
get_latest_version "engenious" "$prereleases" engenious_version
get_latest_version "engenious.ContentTool" "$prereleases" engenious_contenttool_version
get_latest_version "engenious.UI" "$prereleases" engenious_ui_version

update_package_ref() {
    local packageName=$2
    local newVersion="Version=\"$3\""
    local s=$1 regex="<PackageReference([^\>]*)/>"
    local previousLen=${#1}
    while [[ $s =~ $regex ]]; do 
        match=${BASH_REMATCH[0]}
        len=${#match}
        s=${s#*"${BASH_REMATCH[0]}"}
        newLen=${#s}
        index=$previousLen-$newLen-$len
        
        if [[ $match =~ Include[[:space:]]*=[[:space:]]*\"$packageName\" ]]; then
            echo -n "${1::$index}"
            [[ $match =~ Version[[:space:]]*=[[:space:]]*\"[^\"]*\" ]]
            currentVersionString=${BASH_REMATCH[0]}
            replacedVersion=${match/$currentVersionString/$newVersion}
            echo "$replacedVersion"
            endIndex=$index+$len+1
            echo "${1:$endIndex:$previousLen}"
        fi
        

    done

}

file=templates/engenious.UI/engeniousTemplate/engeniousTemplate.csproj

echo "Updating $file"

fileContent=$(cat "$file")
update_package_ref "$fileContent" "engenious" "$engenious_version" > $file

echo "Updated engenious version to: '$engenious_version'"

fileContent=$(cat "$file")
update_package_ref "$fileContent" "engenious.ContentTool" "$engenious_contenttool_version" > $file

echo "Updated engenious.ContentTool version to: '$engenious_contenttool_version'"


fileContent=$(cat "$file")
update_package_ref "$fileContent" "engenious.UI" "$engenious_ui_version" > $file

echo "Updated engenious.UI version to: '$engenious_ui_version'"


file=templates/engenious/engeniousTemplate/engeniousTemplate.csproj

echo "Updating $file"

fileContent=$(cat "$file")
update_package_ref "$fileContent" "engenious" "$engenious_version" > $file

echo "Updated engenious version to: '$engenious_version'"

fileContent=$(cat "$file")
update_package_ref "$fileContent" "engenious.ContentTool" "$engenious_contenttool_version" > $file

echo "Updated engenious.ContentTool version to: '$engenious_contenttool_version'"
