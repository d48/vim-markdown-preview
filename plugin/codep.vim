function! PreviewCD()
  ruby << RUBY

   # get file name and either preview markdown or js with github styling

    VIM.evaluate('&runtimepath').split(',').each do |path|
      $LOAD_PATH.unshift(File.join(path, 'plugin', 'vim-markdown-preview'))
    end

    require('kramdown/kramdown')
	require('cgi')

    text = Array.new(VIM::Buffer.current.count) do |i|
      VIM::Buffer.current[i + 1]
    end.join("\n")

	tmpline = "\n" + text

    VIM::Buffer.current.name.nil? ? (name = 'No Name.md') : (name = Vim::Buffer.current.name)

    if File.extname(name) =~ /\.(html)/
		tmpline = CGI::escapeHTML(tmpline)
	end

    preview_path = VIM.evaluate('&runtimepath').split(',').select{|path| path =~ /vim-markdown-preview/}.first
    cssfile = File.open("#{preview_path}/plugin/styles/github.css")
    style = cssfile.read

	jsFile = File.open("#{preview_path}/plugin/js/highlight.pack.js")
	js = jsFile.read

	mainJs = File.open("#{preview_path}/plugin/js/main.js")
	mjs = mainJs.read

    layout = <<-LAYOUT
  <!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
		  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		  <style type="text/css">
			#{style}
		  </style>
		  <title> #{File.basename(name)} </title>
      </head>
      <body>
		  <div class="container">
				<h1 id="title">
				  #{File.basename(name)}
				</h1>

				<div id="readme">
					<div id="numbers"></div>
					<div id="content" class="markdown-body">
						<pre class="javascript">
							#{tmpline}
						</pre>
					</div>
				</div>
		  </div>

		  <script type="text/javascript" charset="utf-8">
			  #{js}
		  </script>
		  <script type="text/javascript">
			  #{mjs}
		  </script>
      </body>
    </html>
    LAYOUT


    file = File.join('/tmp', File.basename(name) + '.html')
    File.open('%s' % [ file ], 'w') { |f| f.write(layout) }
    Vim.command("silent !open '%s'" % [ file ])
RUBY
endfunction

:command! Cc :call PreviewCD()
