using System;

namespace engeniousTemplate
{
    public static class MainClass
	{
        [STAThread()]
		public static void Main (string[] args)
		{
			using(var game = new engeniousTemplateGame ())
				game.Run();
		}
	}
}
