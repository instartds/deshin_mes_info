/**
* Javascript Document Generator
* https://github.com/senchalabs/jsduck
* https://github.com/senchalabs/jsduck/wiki
*/
Usage: jsduck [options] files/dirs...

For example:

    # Documentation for builtin JavaScript classes like Array and String
    jsduck --output output/dir  --builtin-classes

    # Documentation for your own JavaScript
    jsduck --output output/dir  input-file.js some/input/dir

The main options:

    -o, --output=PATH                Directory to write all this documentation.
        --export=full/examples       Exports docs in JSON.
        --builtin-classes            Includes docs for JavaScript builtins.
        --seo                        Enables SEO-friendly print version.
        --config=PATH                Loads config options from JSON file.
        --encoding=NAME              Input encoding (defaults to UTF-8).
        --exclude=PATH               Exclude input file or directory.

Customizing output:

        --title=TEXT                 Custom title text for the documentation.
        --footer=TEXT                Custom footer text for the documentation.
        --head-html=HTML             HTML for the <head> section of index.html.
        --body-html=HTML             HTML for the <body> section of index.html.
        --css=CSS                    Extra CSS rules to include to the page.
        --message=HTML               (Warning) message to show prominently.
        --welcome=PATH               File with content for welcome page.
        --guides=PATH                JSON file describing the guides.
        --videos=PATH                JSON file describing the videos.
        --examples=PATH              JSON file describing the examples.
        --categories=PATH            JSON file defining categories for classes.
        --no-source                  Turns off the output of source files.
        --images=PATH                Path for images referenced by {@img} tag.
        --tests                      Creates page for testing inline examples.
        --import=VERSION:PATH        Imports docs generating @since & @new.
        --new-since=VERSION          Since when to label items with @new tag.
        --comments-url=URL           Address of comments server.
        --comments-domain=STRING     A name identifying the subset of comments.
        --search-url=URL             Address of guides search server.
        --search-domain=STRING       A name identifying the subset to search from.

Tweaking:

        --tags=PATH                  Path to custom tag implementations.
        --ignore-global              Turns off the creation of 'global' class.
        --external=Foo,Bar,Baz       Declares list of external classes.
        --[no-]ext4-events           Forces Ext4 options param on events.
        --examples-base-url=URL      Base URL for examples with relative URL-s.
        --link=TPL                   HTML template for replacing {@link}.
        --img=TPL                    HTML template for replacing {@img}.
        --eg-iframe=PATH             HTML file used to display inline examples.
        --ext-namespaces=Ext,Foo     Additional Ext JS namespaces to recognize.
        --touch-examples-ui          Turns on phone/tablet UI for examples.
        --ignore-html=TAG1,TAG2      Ignore a particular unclosed HTML tag.

Performance:

    -p, --processes=COUNT            The number of parallel processes to use.
        --[no-]cache                 Turns parser cache on/off (EXPERIMENTAL).
        --cache-dir=PATH             Directory where to cache the parsed source.

Debugging:

    -v, --verbose                    Turns on excessive logging.
        --warnings=+A,-B,+C          Turns warnings selectively on/off.
        --warnings-exit-nonzero      Exits with non-zero exit code on warnings.
        --[no-]color                 Turn on/off colorized terminal output.
        --pretty-json                Turns on pretty-printing of JSON.
        --template=PATH              Dir containing the UI template files.
        --template-links             Creates symlinks to UI template files.
    -d, --debug                      Same as --template=template --template-links.
        --extjs-path=PATH            Path for main ExtJS JavaScript file.
        --local-storage-db=NAME      Prefix for LocalStorage database names.
    -h, --help[=--some-option]       Use --help=--option for help on option.
        --version                    Prints JSDuck version