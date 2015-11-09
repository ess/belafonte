class ObligatoryCommand < Belafonte::App
  title 'obligatory'
end

class UnlimitedCommand < Belafonte::App
  title "unlimitedcommand"

  arg :arg1, times: :unlimited

  mount ObligatoryCommand
end
