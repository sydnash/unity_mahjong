using UnityEngine;

namespace UnityEngine.UI
{
    public class PointerToggle : Toggle
    {
        private bool mClicked = false;

        public bool clicked
        {
            get { return mClicked; }
        }

        public override void OnPointerClick(EventSystems.PointerEventData eventData)
        {
            mClicked = true;
            base.OnPointerClick(eventData);
            mClicked = false;
        }
    }
}
