* Remote debugging options:

      -agentlib:jdwp=transport=dt_socket,server=y,address=5000

  The process will pause and wait for debugger to attach (add `suspend=n` to
  launch without waiting.  If it forks
  additional Java processes they behave the same way (so you have to
  attach again).
  
  With Maven tests use:
  
      mvn -Dmaven.surefire.debug="-agentlib:jdwp=transport=dt_socket,server=y,address=5000" test

  With Spring AOT

      mvn -P native compile spring-boot:process-aot -D spring-boot.aot.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,address=5000"

* Maven site goal does not include the post-site phase (duh).  You have
  to execute "mvn post-site" to get the site *and* post-site to execute

* SVN sparse: http://svnbook.red-bean.com/nightly/en/svn.advanced.sparsedirs.html

* JMX voodoo (http://java.sun.com/j2se/1.5.0/docs/guide/management/agent.html#sysprops):

      -Dcom.sun.management.jmxremote

  and (optionally)

     -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl.need.client.auth=false

# Find and Prune

    $ find . -name .git -prune -o -type f -exec ...

# Split Line on Separator

Split classpath on ":" separator:

    $ echo $CP | tr : \\n

# Docker

Clean up:

    $ docker rm $(docker ps --filter status=exited -q)
    $ docker rmi $(docker images | grep "^<none>" | awk '{print $3}')

Better:

	$ docker system prune -a

# Videos

Show the webcam in a tiny window on screen (`nix-shell -p simplescreenrecorder ffmpeg-full flowblade`):

    $ ffplay /dev/video0 2> /dev/null &
	
To record a video `simplescreenreader`; edit with `flowblade`.

# JShell ProcessBuilder

    $ jshell
    jshell> ProcessBuilder builder = new ProcessBuilder();
    jshell> builder.command("ls")
    jshell> Process process = builder.start();
    jshell> new BufferedReader(new InputStreamReader(process.getInputStream())).lines().forEach(System.out::println)
    jshell> process.waitFor()


Use `builder.command("sh", "-c", "echo bar && echo foo");` to run 2 commands in one shell.

# Zoom

If you see this:

    $ /usr/bin/zoom 
    ZoomLauncher started.
    cmd line: 
    $HOME = /home/dsyer 
    export SSB_HOME=/home/dsyer/.zoom; export QSG_INFO=1; export LD_LIBRARY_PATH=/opt/zoom; /opt/zoom/zoom "" 
    zoom started.
    intel_do_flush_locked failed: Input/output error
    success to create child process,status is 256.
    zoom exited normally.
    Something went wrong while running zoom,exit code is 1.
    ZoomLauncher exit.

Then try this:

    $ LIBGL_ALWAYS_SOFTWARE=1 zoom

# Drawing on the Screen

Otherwise known as annotations. Install `gromit-mpx`:

    $ sudo apt-get install gromit-mpx

Run it. Use its activation key to toggle between drawing and normal mode (add shift to erase, ctrl to hide). The default key is F9 which doesn't work for me, but `gromit-mpx -k F12` works.

With a utility script that does `gromit-mpx -t || gromit-mpx -k F12 -a` you can toggle it on and off, from whatever state it is in. TIP: add that to `~/.config/openbox/lubuntu-rc.xml`:

        <!-- Launch gromit-mpx Ctrl + Alt + G-->
        <keybind key="C-A-G">
          <action name="Execute">
            <command>/home/dsyer/bin/gromit</command>
          </action>
        </keybind>
 
and then

    $ openbox-lxde --reconfigure

Use `man gromit-mpx` for key mappings and options.

# Travis Encrypt

    $ travis encrypt GH_TOKEN=... CI_DEPLOY_PASSWORD='{DESede}xaRkueedpiyiX1ZMspYllQ=='
     
# Java Agents

Useful article/HOWTO: http://dhruba.name/2010/02/07/creation-dynamic-loading-and-instrumentation-with-javaagents/

# YourKit

Use

    -agentpath:<profiler directory>/bin/linux-<arch>/libyjpagent.so

(per [this link](http://www.yourkit.com/docs/java/help/agent.jsp)),
and then go to the "Welcome" tab in YJP where you will see a list of
processes and the one you just started can be clicked on to profile
it.

# Epoch Time

    $ date +"%s"
    
(in seconds)

    $ date -d @1449840163
    
(back to a date)

# RabbitMQ

Start as non-root:

    $ (export RABBITMQ_LOG_BASE=~/tmp/rabbitmq RABBITMQ_MNESIA_BASE=~/tmp/rabbitmq/mnesia && cd && nohup ~/Programs/rabbitmq_server-2.5.0/sbin/rabbitmq-server 2>&1 > tmp/rabbit.log &)

# Oracle XE

Using JEOS VM (username/password = jeos)...

From [http://www.oracle.com/technology/tech/linux/install/xe-on-kubuntu.html]:

Just add:

    deb http://oss.oracle.com/debian unstable main non-free

to /etc/apt/sources.list and then:

    $ sudo apt-get install wget
    $ wget http://oss.oracle.com/el4/RPM-GPG-KEY-oracle -O- | sudo apt-key add - 
    $ sudo apt-get update
    $ sudo apt-get install oracle-xe

Follow the instructions to configure the database.  Important: answer 'yes' to the question about starting the server on startup (you can switch it off later).  Then connect as SYSTEM and do this:

    ALTER SYSTEM SET PROCESSES=150 SCOPE=SPFILE;
    create user SPRING identified by SPRING;
    CREATE ROLE conn;
    GRANT CREATE session, CREATE seqence, CREATE trigger, 
	  CREATE table, CREATE view, 
      CREATE procedure, CREATE synonym,
      ALTER any table, ALTER any sequence, 
      DROP any table, DROP any view, DROP any procedure, DROP any synonym,
	  DROP any sequence, DROP any trigger
      TO conn;
    GRANT conn to SPRING;
    alter user SPRING default tablespace USERS;
    grant unlimited tablespace to SPRING;

Restart the database (using the `init.d` script) to bake in the pfile change, and you are good to go.

N.B. there is a bug in the `init.d` script which means it cannot be used unless start on init is enabled.

## MySQL

    mysql> create database hello_world;
    Query OK, 1 row affected (0.00 sec)

    mysql> grant all on hello_world.* to 'benchmarkdbuser'@'%' identified by 'benchmarkdbpass';
    Query OK, 0 rows affected (0.00 sec)

    mysql> grant all on hello_world.* to 'benchmarkdbuser'@'localhost' identified by 'benchmarkdbpass';
    Query OK, 0 rows affected (0.01 sec)

## Using `rsync` to Synchronize Laptop

Useful command line options

    $ rsync -CaF -f 'merge,C .gitignore' .

(Lists files from the current directory that would be synced if a destination was provided.)

Sync with laptop:

    $ rsync -CvzaF -f 'merge,C .gitignore' . dave:~/Docs/Presentations

and back again:

    $ rsync -CvzaF -f 'merge,C .gitignore' dave:~/Docs/Presentations/ .
	
# Markup PDF

Use `xournal`.

# Markdown

## PDF Generation

Nice blog: [http://sysadvent.blogspot.co.uk/2011/12/day-14-write-your-resume-in-markdown.html][].

## Markdown and Confluence

There is an [HTML Wikiconverter][perlmod] Perl module which might
prove useful.  There is also a confluence dialect, and a [patch][patch] to
make it work better with <pre/> elements (patched `Confluence.pm` in
`/usr/local/share/perl/5.10.1/HTML/WikiConverter`).  Unfortunately the
patch isn't smart enough to convert HTML entities back to text before
rendering them, so code with '>', '<', etc. gets screwed up.

[perlmod]: http://search.cpan.org/~diberri/HTML-WikiConverter-0.68/lib/HTML/WikiConverter.pm

[patch]: http://rt.cpan.org/Public/Bug/Display.html?id=48632

Install `HTML:WikiConverter` (synaptic package manager has in in
Ubunt, or use `cpan`), including the `Confluence` dialect:

    $ sudo cpan
    cpan> install HTML::WikiConverter::Confluence
    cpan> exit

This script (`html2confluence`) can then be used:

    #!/usr/bin/perl

    use HTML::WikiConverter;
    my $wc = new HTML::WikiConverter( dialect => 'Confluence' );

    #### Process incoming text: ###########################
    my $text;
    {
    	local $/;               # Slurp the whole file
    	$text = <>;
    }
    print $wc->html2wiki( $text );

like this

    $ markdown mynotes.md | html2confluence > mynotes.confluence

It works OK, except for the lack of direct mapping between {notes} in
confluence and anything in markdown.  I was using blockquotes in
markdown as an approximation, but that only works if there is no
markup inside it.  I.e. this is fine in markdown

    > _Header_
    > * bullet
    > * another

but results in garbage confluence because it needs all the text in a
blockquote to be in a single paragraph (i.e. same line).

[Jekyll](https://github.com/mojombo/jekyll) is used for gh-pages and
is a really cool way to run a basic wiki.  I once had some issues with one
of the gem dependencies which had an invalid date format in the
gemspec.  Had to edit it manually to remove the timestamp from the
date. More recently I have always used the `github-pages` gem which
curates the dependencies needed for Github to build your pages for you.

## Add Maths

<script type="text/javascript" src="LaTeXMathML.js"></script>
  
Really cool: [http://www.maths.nottingham.ac.uk/personal/drw/lm.html]().  E.g. $A\cupB$, $A\longrightarrowB$.

Also possibly useful (but no tutorial and looks complex): [http://www.mathjax.org]()

## Using Appengine for static content

Useful article on
[using GAE for static content](http://blog.engelke.com/2008/07/30/google-appengine-for-web-hosting/). Essentially
you have a static config file and some content in a subdirectory (no
`.py` code):

    application: dsyerstatic
    version: 1
    runtime: python
    api_version: 1

    handlers:
    - url: (.*)/
      static_files: static\1/index.html
      upload: static/index.htmla

    - url: /
      static_dir: static

I tried installed the python SDK using pip:

    $ sudo apt-get install libyaml-dev python-dev
    $ sudo pip install ez_setup google-appengine
    
But the `appcfg.py` tool seemed to be missing dependencies.  Ended up
downloading the whole SDK from google and using that, which worked.

## Using Cloud Foundry for Static Content

    $ cd ~/dev/identity/diagrams
    $ jekyll
    $ cp -rf _site/* ~/Documents/dsyerstatic.cloudfoundry.com/static/
    $ (cd ~/Documents/dsyerstatic.cloudfoundry.com; vmc update dsyerstatic)

It's a node.js app.

### Simple HTTP Server with Python

Serve current directory as a static website:

```
$ python -m http.server 1234
```

## SSH and UI on GCP

### With TCP to local X server

* Set up lightdm to launch X with `-listen tcp` (and not with `-nolisten tcp`). You can check you got it right by running `pgrep -al X`. Might need to restart (not just log out and back in): https://lanforge.wordpress.com/2018/03/30/enabling-remote-x-connections/

* Check that X is listening on port 6000 (`netstat -tlnp | grep 6000`). It listens on `6000+$DISPLAY`.

* Enable hosts to connect: `xhost +`.

* Set `DISPLAY=:0` on remote machine and run X client (e.g. emacs, google chrome etc.).

### With VNC and remote X server

* Set up passwordless SSH (log into the remote VM and cat your `id_rsa.pub` to the end of `.ssh/authorized_keys`).
* Create a firewall rule for `tcp:5901` and enable it on the instance

Install an X server, e.g.

```
$ sudo apt-get install gnome-core vnc4server netcat
$ wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$ sudo dpkg -i google-chrome-stable_current_amd64.deb
```

Put some stuff in `.vnc/xstartup`. E.g.

```
#!/bin/sh

# Uncomment the following two lines for normal desktop:
unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc

#[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
#[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
#xsetroot -solid grey
#vncconfig -iconic &
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &

metacity &
gnome-settings-daemon &
gnome-panel &
```

Run the server, and verify it works:

```
$ vncserver
$ nc localhost 5901
RFB 003.008
```

Then go to localhost and set up a tunnel, then 

```
$ ssh -L 5901:localhost:5901 ui
ui$ export DISPLAY=:1
ui$ google-chrome
```

and then run the client as well locally:

```
$ gvncviewer localhost:1:5901
```

## Annoying Stale Entries in .ssh/known_hosts

Using sed to remove the offending line:

    $ ssh secrethost
    Offending key in /home/ccm/.ssh/known_hosts:46
    [...]
    Host key verification failed.
    $ sed -i "46 d" ~/.ssh/known_hosts
    $ ssh secrethost
    The authenticity of host 'secrethost (1.2.3.4)' can't be established.
    RSA key fingerprint is ab:cd:ef:ab:cd:ef:ab:cd:ef:ab:cd:ef:ab:cd:ef:ab.
    Are you sure you want to continue connecting (yes/no)?


## Ubuntu and Java Host Resolution

Useful discussion from Costin:
[https://jira.springsource.org/browse/SGF-28](https://jira.springsource.org/browse/SGF-28).
Need to add the local hostname as an alias for 127.0.0.1 (as well as
the default on ubuntu which is 127.0.1.1 for some reason).

## VMW vCenter

http://buildweb.eng.vmware.com/ob/?product=vcva&branch=esx50

## Tomcat

Starts up *much* faster with `-Djava.security.egd=file:/dev/./urandom`

## Maven Release

Normal process:

    $  mvn release:prepare -P fast,all -Dtag=X.X.X -DreleaseVersion=X.X.X -DdevelopmentVersion=X.X.X.BUILD-SNAPSHOT -DautoVersionSubmodules=true

Maven 3 does not allow read-only git urls, so you need 

    <developerConnection>scm:git:ssh://git@github.com/spring-projects/spring-security-oauth.git</developerConnection>


Using a branch:

    $ mvn release:branch -DbranchName=1.0.0.p6 -DreleaseVersion=1.0.0.p6 -DdevelopmentVersion=1.0.0.BUILD-SNAPSHOT -DautoVersionSubmodules=true -DpushChanges=false -DupdateBranchVersions=true -DupdateWorkingCopyVersions=false
    
We added `-DpushChanges=false` so that the push can be managed
manually - it makes sense to move master back to the commit *before*
the release branch if you don't change the development version.  You
need a newish version of the release plugin for the push changes flag
to be recognised (e.g. 2.3).

To just update the poms and leave the change uncommitted:

    $ mvn release:update-versions -DpushChanges=false -DdevelopmentVersion=1.0.0.p5 -DautoVersionSubmodules=true 

BUT... this adds "-SNAPSHOT" to the release version.  Grr.

## Maven Central

Link: https://oss.sonatype.org/

Sonatype Docs: http://central.sonatype.org/pages/ossrh-guide.html

Guide: https://maven.apache.org/guides/mini/guide-central-repository-upload.html

## Maven Deploy with Manual Repository

    $ mvn deploy -DskipTests=true -DaltDeploymentRepository=repo.spring.io::default::https://repo.spring.io/libs-snapshot-local
    
(`-DaltReleaseDeploymentRepository` and `-DaltSnapshotDeploymentRepository` can also be used).

## Screen

(Gave up in the end - gnome has good tab support with CTRL-SHIFT-T.)

Basic [HOWTO](https://help.ubuntu.com/community/Screen)

    $ sudo apt-get install screen
    $ screen
    
Some `.screenrc` snippets from the internet:

    # rebind ^a to ^x (^x is now available as ^xX).
    escape ^xX

    # kill startup message
    startup_message off

    # define a bigger scrollback, default is 100 lines
    defscrollback 1024

    # An alternative status to display a bar at the bottom
    caption always "%{=b dw}%?%{-b dg}%-Lw%?%{+b dk}(%{+b dr}%n:%t%{+b dk})%?(%u)%?%{-b dw}%?%{-b dg}%+Lw%?%{-b dw}"

[Useful tutorial on scrolling](http://www.saltycrane.com/blog/2008/01/how-to-scroll-in-gnu-screen/)

Split horizontally: `^x|`. Split vertically: `^xS` (shift-S). To remove a pane `^x:remove` (no key binding). To close all splits `^xQ`.

## Jackson Deserialization

    @SuppressWarnings("unused")
    @JsonAnySetter
    private void setRemaining(String key, Object value) {
    	System.err.println(key + ": " + value);
    }

# Eclipse Tips

* `CTRL-3` opens a dialog for commands.  E.g. `CTRL-3 swc` = "Show Whitespace" (toggles whitespace in an editor)

# Emacs Tips

* Word count.  `M-=` counts the lines and characters in region, but
  not words.
* `M-!` runs a shell command in the current directory (if the
  current buffer is a file), so `M-!` then TAB will list the files,
  select the one you want!
* `M-|` runs a shell comand on region (so counting a subset of the
  current buffer is possible).

# Github Tips

Pull requests.  Maintaining the author tags can be a challenge if the pull is against an old master.  You can often cherry pick though, if it's a single commit:

    $ git fetch git://github.com/XXXX/spring-batch master && git cherry-pick FETCH_HEAD
	
## Actions

[Tutorial on debugging](https://github.com/spring-projects/spring-guice/milestones). Add a step with `uses: valeriangalliat/action-sshd-cloudflared@v1` and 
the env vars you want to use in the main build step and run the shell command line logged in that step.
    
# HTTP Monitoring with tcpdump

    $ sudo tcpdump 'tcp port 8080' -i any -A
    $ sudo tcpdump 'tcp port 80 and host uaa.cf101.dev.las01.vcsops.com' -i any -A
    
(Without `-A` you don't see the plain text in headers and locations.)

# SSL With Self-Signed Certs

Create server cert (JKS format):

```
$ keytool -genkeypair -alias servercert -keyalg RSA \
  -dname "CN=Web Server,OU=Unit,O=Organization,L=City,S=State,C=US" \
  -keypass password -keystore server.jks -storepass password
```

Use it in Tomcat:

```java
@Bean
public EmbeddedServletContainerFactory servletContainer() {
   TomcatEmbeddedServletContainerFactory tomcat = new TomcatEmbeddedServletContainerFactory();
   tomcat.addConnectorCustomizers(new TomcatConnectorCustomizer() {
   	@Override
   	public void customize(Connector connector) {
      SslApplication.this.customize(connector);
   	}
   });
   return tomcat;
}

private Connector customize(Connector connector) {
   Http11NioProtocol protocol = (Http11NioProtocol) connector.getProtocolHandler();
   try {
   	File keystore = getKeyStoreFile();
   	File truststore = keystore;
   	connector.setScheme("https");
   	connector.setSecure(true);
   	connector.setPort(8443);
   	protocol.setSSLEnabled(true);
   	protocol.setKeystoreFile(keystore.getAbsolutePath());
   	protocol.setKeystorePass("password");
   	protocol.setTruststoreFile(truststore.getAbsolutePath());
   	protocol.setTruststorePass("password");
   	protocol.setKeyAlias("servercert");
   	return connector;
   }
   catch (IOException ex) {
   	throw new IllegalStateException("cant access keystore: [" + "keystore"
      	+ "] or truststore: [" + "keystore" + "]", ex);
   }
}
```

## X.509 Authentication

Generate key pair for user authentication in a new keystore
(`user.p12` can now be imported into a browser as a new
certificate identity):

```
$ user=rod
$ keytool -genkeypair -alias user -keystore user.p12 \
   -storetype pkcs12 -keyalg RSA -dname "CN=user,OU=Unit,O=Organization,L=City,S=State,C=US" \
   -keypass password -storepass password
```

Export the client certificate and import it into the server keystore,
so it can be verified:

```
keytool -exportcert -alias user -file user.cer -keystore user.p12 -storetype pkcs12 -storepass password
keytool -importcert -keystore server.jks -alias user -file user.cer -v -trustcacerts -noprompt -storepass password
rm user.cer
```

Then change the Tomcat `Connector` to add the client authentication:

```
   protocol.setClientAuth("true");
```

You can now connect with the browser. To connect with curl, you need a
PEM formatted version of the user store (which contains a private key
so obviously needs to be kept secret):

```
$ openssl pkcs12 -in user.p12 -out user.pem
$ curl -k -v --cert user.pem https://localhost:8443/hello
```

Curl uses the private key to sign the certificate and then sends it to
the server.

# Two Computers, One Keyboard

* `x2x` appears to be quite smooth (e.g. [here](http://www.linuxjournal.com/content/share-keyboardmouse-between-multiple-computers-x2x)):

        $ ssh -X laptop x2x -south -to :0
        
  The problem with that is that the laptop screen has to be smaller
  than the local one, otherwise you can't reach the edges with the
  mouse. (Possible solution with `xrandr`?)

* Synergy is OK.  A bit flaky sometimes. Barrier is better and more open community.

* `Xdmx` supposedly can be used to create a synthetic screen from
  multiple servers.  It never really worked for me.  Allegedly Ubuntu
  repositories have buggy versions?  E.g. (with displays :1 and :2 both
  active)
  
          $ startx -- /usr/bin/Xdmx :3 +xinerama -display :1 -display :2 -norender -noglxproxy -ignorebadfontpaths
  
  Has a tendency to hose the keyboard (CTRL and ALT stop working).

* Simply running X windows from remote box on the local one works
  pretty well:
  
          $ ssh -X -c blowfish-cbc laptop
          $ x-terminal-emulator &
          
  The `ssh` command logs into the remote machine and opens a new X
  display (`env | grep DISPLAY` to see the screen id), which looks
  like it is on localhost (laptop in the example), but renders on the
  original host.
  
  Works pretty well, but you don't have the nice UI for launching
  apps.  Also doesn't work with synergy because it thinks the edge of
  the screen is in the middle of the app.
  
* VNC has the ability to create a virtual X display.  E.g. create
  display :2 with

        $ vnc4server :2 -geometry 1400x788 -alwaysshared
        
  Then you can connect from a remote machine using VNC (`laptop:2`).
  It seems to be very difficult to get a useful window manager running
  in there though.

# VNC

Desktop sharing works linux to linux pretty well. OSX users trying to connect
to Ubuntu seem to have issues with security. You can work around that by using

    $ gsettings set org.gnome.Vino require-encryption false

# OpenVPN

Awesome guide [here](https://help.ubuntu.com/11.10/serverguide/openvpn.html).
The only issues I had setting it up:

* What to put in `vars` for `PKCS11_MOD_PATH`.  Answer: install
  `opensc`, and then find the module at `/usr/lib/pkcs11-spy.so`.
* `whichopensslcnf` didn't work because `openssl` was at `1.0.1` and
  the config files only went up to `1.0.0`.  Copied the `1.0.0`
  version to `openssl.cnf`.
* The client key had to be chowned and mod 600 before it was accepted
  by the VPN client software.
* Client had to have LZO compression enabled (VPN advanced config tab)
* Key passphrase is jack's boat name
* Even though it says "Windows-specific" you need to push DNS options:

        push "dhcp-option DNS 8.8.8.8"
        push "dhcp-option DNS 8.8.4.4"

Opened up port 1194 to internet in router and now can VPN into server
at Virgin external IP (`82.5.196.82` currently).  Set up once a day
cron job to do this in case it changes:

    $ curl http://www.hashemian.com/whoami/ | grep REMOTE_ADDR

Also useful: [PPTP Blog](http://blog.riobard.com/2011/11/12/pptp-vpn-on-ubuntu/), and [OpenVPN and PPTP Blog](http://aaronlevie.blogspot.com/2011/07/openvpn-and-pptp-server-setup.html)

# PPTP

Install PPTPD:

    $ sudo apt-get install pptpd

Add some IP configuration to `/etc/pptpd.conf`, e.g.

    localip 10.8.1.1
    remoteip 10.8.1.100-200

Add account details to `/etc/ppp/chap-secrets`, e.g.

    # client        server  secret                  IP addresses
    dsyer           pptpd   secret                  "*"
    
Then you can log in and set up a VPN, but only connect to the
`10.8.1.1` network.  To get to the internet you need some natting in
iptables

    $ sudo -i
    # echo 1 > /proc/sys/net/ipv4/ip_forward
    
and add a couple of lines to `/etc/sysctl.conf` (so the change above
persists across restarts):

    # Uncomment the next line to enable packet forwarding for IPv4
    net.ipv4.ip_forward=1
    
and restart

    # sysctl -p
    
and some firewall rules

    # iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    # iptables -A FORWARD -i eth0 -o ppp+ -j ACCEPT
    # iptables -A FORWARD -o eth0 -i ppp+ -j ACCEPT
    # iptables -L -n -v
    ... check contents
    # iptables -L -n -v -t nat
    ... ditto

Then we should be able to ping internet sites by IP (but not by name
yet).  To resolve internet sites by name we need to change some DNS
settings in the client, and the best way is to let the server tell the
client how to do it.  Edit `/etc/ppp/pptpd-options` and add references
to external DNS servers, e.g.

    ms-dns 8.8.8.8
    ms-dns 8.8.4.4

(this seems to be important for clients on Ubuntu and iOS, not just
Windows, as implied by the "ms").

# Local Server Tunnel

https://ngrok.com/

    $ sudo apt-get install ngrok-client

Or 

    $ nix-shell -p cloudflared
    $ cloudflared tunnel --url http://localhost:8080

# SSH Tunnel

Tunnel from "remote:8080" to "localhost:8000":

    $ ssh -L 8000:localhost:8080 remote -N

With Vagrant

    $ vagrant ssh -- -L 8000:localhost:8080 -N

# Java Logging

Debug logging:

    $ JAVA_OPTS=-Djava.util.logging.config.file=logging.properties groovysh
    ...
    
Example `logging.properties`

    handlers = java.util.logging.ConsoleHandler
    .level = INFO
    java.util.logging.ConsoleHandler.level = FINE
    sun.net.www.protocol.http.HttpURLConnection.level = ALL
    org.apache.http.level = ALL
    groovyx.net.http.level = ALL

# CORS

```
$ curl -v -X OPTIONS -H "Origin: http://localhost:9000" -H "Access-Control-Request-Method: GET" -H "Access-Control-Request-Headers: X-Foo" rest-service.guides.spring.io/greeting
```

If you see `Access-Control-Allow-*` headers in the response then it is working. Should work with Spring Security as well but the status code will be 401 for an unauthenticated request.

# CRIU

```
$ sudo apt-get install criu
$ mvn clean install
$ nohup java -XX:-UsePerfData -jar target/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar 2>&1 &
$ echo $! > pid.file
$ sudo criu dump -t $(cat pid.file) --shell-job
$ sudo criu restore --shell-job
```

# Nix

https://nixos.org/nix/

Useful config file collections for ideas (mostly nixos specific):

- https://github.com/bjornfor/nixos-config
- https://github.com/bennofs/etc-nixos
- https://github.com/auntieNeo/nixrc

Articles and user guides:

- https://github.com/samdroid-apps/nix-articles
- https://nixos.org/nix/manual
- https://nixos.org/nixos/nix-pills/

# Wifi

```
$ sudo nmcli dev wifi
```

## Google Chrome PPA

```
$ wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
$ sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
$ sudo apt update
$ sudo apt install google-chrome-unstable
```

## Postgres:

    $ sudo apt-get install postgresql
    $ sudo update-rc.d postgresql disable

Then you can start and stop the service with

    .$ sudo service postgresql start|stop

To interact with the database you need to be logged in as the local postgres user:

    .$ sudo -u postgres createdb uaa
    .$ sudo -u postgres psql -d uaa
    postgres=# create role root NOSUPERUSER LOGIN INHERIT CREATEDB
    postgres=# alter role root with password 'changeme'
    postgres=# \q

To connect locally with JDBC that should be enough.  To use the command line for the uaa user, replace all entries in the default `/etc/postgresql/*/main/pg_hba.conf` with

    local	all		all					trust
    host	all		all		127.0.0.1/32		trust
    host	all		all		::1/128			trust

after which you can log in on the command line:

    $ psql -d uaa -U root -W
    Password for user root: 
    psql (9.1.1)
    Type "help" for help.
    uaa=> \q
	
## Lastpass CLI

In `shell.nix`:

    with import <nixpkgs> {
      overlays = [
        (self: super: {
          lastpass-cli = super.lastpass-cli.overrideAttrs (oldAttrs: rec {
            version = "1.6.0"; # this is the default in nixpkgs/main
            src = self.fetchFromGitHub {
              owner = "lastpass";
              repo = "lastpass-cli";
              rev = "v${version}";
              sha256 = "054dvz273m0w30lf85qidwzmgwrvdjasdgmnhrgix4wjsrikrw8p";
            };
            patches = [];
        });
        })
      ];
    };
    mkShell {
      buildInputs = [
        lastpass-cli
       ];
    }

Then

    $ nix-shell
	$ lpass login --trust david_syer@hotmail.com
	$ lpass sync
	$ lpass show --password 8626486485653997789

## CIFS Mounts

The username is the Windows local user and the password is how you log onto the windows box (probably Microsoft Live account):

    .$ sudo mount -t cifs -o user=david,password="$(lpass show --password 8626486485653997789)",uid=$(id -u),gid=$(id -g) //alien/Users/david /mnt/alien/
