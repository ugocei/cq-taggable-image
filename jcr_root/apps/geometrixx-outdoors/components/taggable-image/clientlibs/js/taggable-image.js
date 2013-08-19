function makeTaggable(path) {
    $('div.image img.taggable').photoTag({
        requestTagsUrl: path + '/tags.children.json',
        addTagUrl: path + '/tags/',
        parametersForNewTag: {
            name: {
                parameterKey: 'text',
                isAutocomplete: true,
                autocompleteUrl: path + '.users',
                label: 'Name'
            }
        }
    });
}
