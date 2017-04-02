class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.5.13/bin/apache-tomcat-8.5.13.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.13/bin/apache-tomcat-8.5.13.tar.gz"
    sha256 "19d5218dfc0a759cd47ec6ac371de69f5d005ce4327a6677e945b64453713c75"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.13/bin/apache-tomcat-8.5.13-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.13/bin/apache-tomcat-8.5.13-fulldocs.tar.gz"
      version "8.5.13"
      sha256 "6a7d412e7117a29e392476898a3a92ef98c837ac39347ee89e52ce4740c28269"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M19/bin/apache-tomcat-9.0.0.M19.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M19/bin/apache-tomcat-9.0.0.M19.tar.gz"
    version "9.0.0.M19"
    sha256 "6e21a9e2c4d1549d446a90de674ebe2bd873413f4b752726bc96b154226ad153"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M19/bin/apache-tomcat-9.0.0.M19-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M19/bin/apache-tomcat-9.0.0.M19-fulldocs.tar.gz"
      version "9.0.0.M19"
      sha256 "8ae37d1538756603ddeef925e7ab3a4696c453851cb01760bb6991b3846327a6"
    end
  end

  bottle :unneeded

  option "with-fulldocs", "Install full documentation locally"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    File.exist? testpath/"logs/catalina.out"
  end
end
