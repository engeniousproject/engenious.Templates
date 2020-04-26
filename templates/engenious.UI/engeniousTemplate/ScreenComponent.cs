using engenious;
using engenious.UI;

namespace engeniousTemplate
{
    public class ScreenComponent : BaseScreenComponent
    {
        public ScreenComponent(Game game) : base(game)
        {

        }

        protected override void LoadContent()
        {
            base.LoadContent();
            
            NavigateToScreen(new MainScreen(this));
        }
    }
}