class SubMountable < Belafonte::App
  title 'submountable'
end

class Mountable < Belafonte::App
  title "mountable"

  arg :yomomma

  mount SubMountable
end

class Mounter < Belafonte::App
  title 'main'

  mount Mountable
end
