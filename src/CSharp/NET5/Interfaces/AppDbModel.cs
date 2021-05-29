namespace AppApiAuthenticator.Interfaces {

    /// <summary>
    /// Interface required to initialize the AppAuthServer
    /// The class contaning the AppID's and Keys must conform with this interface
    /// </summary>
    public interface IAppDbModel {

        /// <summary>
        /// GUID of the APP
        /// </summary>
        System.Guid AppAuthID { get; set; }

        /// <summary>
        /// Key of the APP
        /// </summary>
        string Key { get; set; }
    }
}