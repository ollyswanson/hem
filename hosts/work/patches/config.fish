function proj
    cd $HOME/passfort/MiniFort/projects
    cd (fd --type directory --follow | fzf)
end

setenv TILT_HOST '0.0.0.0'
