using System;
using System.ComponentModel;
using System.Reflection;

namespace AppApiAuthenticator {

    /// <summary>
    /// Exception when the Enum can't be parsed
    /// </summary>
    public class InvalidEnumException : Exception
	{
        /// <summary>
        /// Default initializer when there's no data
        /// </summary>
		public InvalidEnumException() { }

        /// <summary>
        /// Default initializer, for message only
        /// </summary>
        /// <param name="message">Error message</param>
		public InvalidEnumException(string message) : base(message) { }

        /// <summary>
        /// Default initializer, for message and inner exception
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="inner">Inner exception</param>
		public InvalidEnumException(string message, Exception inner) : base(message, inner) { }
	}

    /// <summary>
    /// Adds extensions to classes
    /// </summary>
    static class extensionClass {
		
        /// <summary>
        /// Gets the description of the enumerator
        /// </summary>
        /// <param name="e">The enumerator</param>
        /// <returns>The description as string</returns>
        public static string getDescription(this Enum e)
        {
            Type eType = e.GetType();			
            string eName = Enum.GetName(eType, e);
            if (eName != null) {
                FieldInfo fieldInfo = eType.GetField(eName);
                if (fieldInfo != null) {
                    DescriptionAttribute descriptionAttribute = Attribute.GetCustomAttribute(fieldInfo, typeof(DescriptionAttribute)) as DescriptionAttribute;
                    if (descriptionAttribute != null) {
                        return descriptionAttribute.Description;
                    }
                }
            }
            return null;
        }
    }

}