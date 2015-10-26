class Argumentative < Belafonte::App
  title "argumentative"

  arg :whatever

  arg :blah, times: 2

  arg :boy_howdy, times: :unlimited
end
