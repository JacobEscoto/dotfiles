package system

import (
	"context"
	"net"
	"time"
)

// NetworkStatus represents the connectivity state
type NetworkStatus string

const (
	StatusOnline  NetworkStatus = "Online"
	StatusOffline NetworkStatus = "Offline"
)

// GetNetworkStatus retrieves the current status of the internet connection.
func GetNetworkStatus() NetworkStatus {
	context, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	var dialer net.Dialer

	endpoints := []string{"1.1.1.1:53", "8.8.8.8:53"}

	for _, endpoint := range endpoints {
		connection, err := dialer.DialContext(context, "tcp", endpoint)
		if err == nil {
			//nolint:errcheck
			defer connection.Close()

			return StatusOnline
		}
	}
	return StatusOffline
}
