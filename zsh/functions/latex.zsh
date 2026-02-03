# LaTeX create template functions

TEX_TEMPLATE_PRESENTATION="$HOME/dev/templates/tex-presentation"
TEX_TEMPLATE_ARTICLE="$HOME/dev/templates/tex-article"

createmplate() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: createmplate <type> <name>"
    echo "Types: presentation, article"
    return 1
  fi

  local template_type="$1"
  local project_name="$2"
  local dest_dir="$PWD/$project_name"
  local source_dir=""

  if [[ "$template_type" != "presentation" && "$template_type" != "article" ]]; then
    echo "Error: Unknown template type '$template_type'"
    echo "Valid types: presentation, article"
    return 1
  fi

  if [[ -d "$dest_dir" ]]; then
    echo "Error: Directory '$dest_dir' already exists"
    return 1
  fi

  if [[ "$template_type" == "presentation" ]]; then
    source_dir="$TEX_TEMPLATE_PRESENTATION"
  else
    source_dir="$TEX_TEMPLATE_ARTICLE"
  fi

  cp -r "$source_dir" "$dest_dir"
  
  echo "Created $template_type template in $dest_dir/"
  echo "Files copied from template: $(ls -1 "$source_dir" | wc -l) items"

  return 0
}
