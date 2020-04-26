using System;
using engenious;

namespace engeniousTemplate
{
    public class engeniousTemplateGame : Game
    {
        protected override void Initialize()
        {
            var screenComponent = new ScreenComponent(this);

            Components.Add(screenComponent);
            base.Initialize();
        }
    }
}
